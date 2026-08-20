class VendorAdjustimentsController < ApplicationController
  before_action :set_vendor_adjustiment, only: %i[ show edit update destroy ]

  # GET /vendor_adjustiments or /vendor_adjustiments.json
  def index
    @active_link = "adjustiments"

    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= Date.current.to_s

    filtered_adjustments =
      VendorAdjustiment.search(params)

    @vendor_adjustiments =
      filtered_adjustments
        .order(adjustment_date: :desc, id: :desc)
        .page(params[:page])
        .per(20)

    @total_debits =
      filtered_adjustments
        .debit
        .sum(:amount)

    @total_credits =
      filtered_adjustments
        .credit
        .sum(:amount)

    @net_adjustments =
      @total_credits - @total_debits

    @purchase_type_totals = {}

    PurchaseType.find_each do |purchase_type|
      @purchase_type_totals[purchase_type] =
        filtered_adjustments
          .where(purchase_type_id: purchase_type.id)
          .sum(:amount)
    end
  end

  # GET /vendor_adjustiments/1 or /vendor_adjustiments/1.json
  def show
  end

  # GET /vendor_adjustiments/new
  def new
    @active_link = "adjustiments"
    @vendor_adjustiment = VendorAdjustiment.new(
      adjustment_date: Date.current,
      adjustment_type: "credit",
      adjustment_category: "manual"
    )
  end

  # GET /vendor_adjustiments/1/edit
  def edit
    @purchase_types = PurchaseType.where("name != ?", "Normal")
    @products = NileProduct.all
  end

  # POST /vendor_adjustiments or /vendor_adjustiments.json
  def create
    @active_link = "adjustiments"
    @vendor_adjustiment = VendorAdjustiment.new(vendor_adjustiment_params)

    @vendor_adjustiment.user = current_user
    @vendor_adjustiment.territory = current_territory
    @vendor_adjustiment.adjustment_category = "manual"

    if @vendor_adjustiment.save
      redirect_to vendor_adjustiment_path(@vendor_adjustiment),
                  notice: "Vendor adjustment created successfully."
    else
      render :new,
            status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vendor_adjustiments/1 or /vendor_adjustiments/1.json
  def update
    respond_to do |format|
      if @vendor_adjustiment.update(vendor_adjustiment_params)
        format.html { redirect_to vendor_adjustiments_path, notice: "Vendor adjustiment was successfully updated." }
        format.json { render :show, status: :ok, location: @vendor_adjustiment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vendor_adjustiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendor_adjustiments/1 or /vendor_adjustiments/1.json
  def destroy
    @vendor_adjustiment.destroy!

    respond_to do |format|
      format.html { redirect_to vendor_adjustiments_path, status: :see_other, notice: "Vendor adjustiment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor_adjustiment
      @vendor_adjustiment = VendorAdjustiment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_adjustiment_params
      params.require(:vendor_adjustiment).permit(
        :purchase_type_id,
        :adjustment_date,
        :adjustment_type,
        :amount,
        :ref_no,
        :description
      )
    end
end
