class CustomerAdjustmentsController < ApplicationController
  before_action :set_customer_adjustment, only: %i[ show edit update destroy approve cancel]
  before_action :set_sale, only: [:new, :create]
  # GET /customer_adjustments or /customer_adjustments.json
  def index
    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= Date.current.to_s

    filtered_adjustments = CustomerAdjustment.search(params)

    @customer_adjustments = filtered_adjustments.includes(:sale,:customer,:created_by,:approved_by).order(adjustment_date: :desc,id: :desc).page(params[:page]).per(20)

    approved_adjustments = filtered_adjustments.where(status: "approved")

    @total_credit_notes = approved_adjustments
                            .where(adjustment_type: "credit_note")
                            .sum(:total_amount)

    @total_debit_notes = approved_adjustments
                          .where(adjustment_type: "debit_note")
                          .sum(:total_amount)

    @net_adjustment = @total_debit_notes.to_d - @total_credit_notes.to_d
    @active_link = "customer_adjustments"
  end

  # GET /customer_adjustments/1 or /customer_adjustments/1.json
  def show
    @customer_adjustment = CustomerAdjustment
                           .includes(
                             :sale,
                             :customer,
                             :created_by,
                             :approved_by,
                             customer_adjustment_items: [
                               :sale_item,
                               :nile_product
                             ]
                           )
                           .find(params[:id])
    @active_link = "customer_adjustments"
  end

  # GET /customer_adjustments/new
  def new
    @customer_adjustment = @sale.customer_adjustments.new(
      customer: @sale.customer,
      adjustment_type: params[:adjustment_type],
      adjustment_date: Date.current,
      created_by: current_user
    )

    @sale.sale_items.each do |sale_item|
      @customer_adjustment.customer_adjustment_items.build(
        sale_item: sale_item,
        nile_product: sale_item.nile_product,
        unit_price: sale_item.amount,
        quantity: 0
      )
    end
    @active_link = "customer_adjustments"
  end

  # GET /customer_adjustments/1/edit
  def edit
  end

  # POST /customer_adjustments or /customer_adjustments.json
  def create
    @customer_adjustment =
      @sale.customer_adjustments.new(customer_adjustment_params)

    @customer_adjustment.customer = @sale.customer
    @customer_adjustment.created_by = current_user

    if @customer_adjustment.save
      redirect_to customer_adjustment_path(@customer_adjustment), notice: "Adjustment created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customer_adjustments/1 or /customer_adjustments/1.json
  def update
    respond_to do |format|
      if @customer_adjustment.update(customer_adjustment_params)
        format.html { redirect_to @customer_adjustment, notice: "Customer adjustment was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_adjustment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @customer_adjustment.approve!(current_user)

    redirect_to customer_adjustment_path(@customer_adjustment), notice: "Adjustment approved successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to customer_adjustment_path(@customer_adjustment), alert: e.record.errors.full_messages.to_sentence
  end

  def cancel
    @customer_adjustment.cancel!

    redirect_to customer_adjustment_path(@customer_adjustment),
                notice: "Adjustment cancelled successfully."
  end

  # DELETE /customer_adjustments/1 or /customer_adjustments/1.json
  def destroy
    @customer_adjustment.destroy!

    respond_to do |format|
      format.html { redirect_to customer_adjustments_path, status: :see_other, notice: "Customer adjustment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_sale
      @sale = Sale.find(params[:sale_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_customer_adjustment
      @customer_adjustment = CustomerAdjustment
                  .includes(
                    :sale,
                    :customer,
                    :created_by,
                    :approved_by,
                    customer_adjustment_items: [
                      :sale_item,
                      :nile_product
                    ]
                  )
                  .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_adjustment_params
      params.require(:customer_adjustment).permit(
      :adjustment_type,
      :adjustment_date,
      :reason,
      customer_adjustment_items_attributes: [
        :id,
        :sale_item_id,
        :nile_product_id,
        :quantity,
        :unit_price,
        :discount_amount,
        :tax_amount,
        :affects_stock,
        :reason,
        :_destroy
      ]
    )
    end
end
