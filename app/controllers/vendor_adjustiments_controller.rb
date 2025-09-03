class VendorAdjustimentsController < ApplicationController
  before_action :set_vendor_adjustiment, only: %i[ show edit update destroy ]

  # GET /vendor_adjustiments or /vendor_adjustiments.json
  def index
    @territory = Territory.find(current_territory.id)
    @vendor_adjustiments = @territory.vendor_adjustiments.order(created_at: :desc).page(params[:page]).per(15)
  end

  # GET /vendor_adjustiments/1 or /vendor_adjustiments/1.json
  def show
  end

  # GET /vendor_adjustiments/new
  def new
    @vendor_adjustiment = VendorAdjustiment.new(adjustment_date:Date.today)
    @purchase_types = PurchaseType.where("name != ?", "Normal")
    @vendor_adjustiment.vendor_adjustiment_items.build
    @products = NileProduct.all
  end

  # GET /vendor_adjustiments/1/edit
  def edit
    @purchase_types = PurchaseType.where("name != ?", "Normal")
    @products = NileProduct.all
  end

  # POST /vendor_adjustiments or /vendor_adjustiments.json
  def create
    @vendor_adjustiment = VendorAdjustiment.new(vendor_adjustiment_params)

    respond_to do |format|
      if @vendor_adjustiment.save
        format.html { redirect_to vendor_adjustiments_path, notice: "Vendor adjustiment was successfully created." }
        format.json { render :show, status: :created, location: @vendor_adjustiment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vendor_adjustiment.errors, status: :unprocessable_entity }
      end
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
      params.require(:vendor_adjustiment).permit(:user_id, :purchase_type_id, :adjustment_date, :territory_id, :journal_no, :ref_no, 
      vendor_adjustiment_items_attributes: [:id, :nile_product_id, :quantity, :quantity_sold, :_destroy])
    end
end
