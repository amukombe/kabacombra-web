class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy ]

  # GET /sales or /sales.json
  def index
    @sales = Sale.search(params).page(params[:page]).per(20)
    @active_link = "sales"
  end

  # GET /sales/1 or /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @active_link = "new"
    @sale = Sale.new(sale_date: DateTime.now)
    @products = LoadingOrderItem.joins(:loading_order).where(loading_orders:{sales_man: current_user.employee.id})
    @customers = current_territory.customers
    @employees = current_territory.employees
    @sale.sale_items.build
    #@sale.sale_empties.build
    @empties = EmptyType.all
    @empties.each do |empty_type|
      @sale.sale_empties.build(empty_type: empty_type) # Build SaleEmpty for each EmptyType
    end
  end

  # GET /sales/1/edit
  def edit
    @products = LoadingOrderItem.joins(:loading_order).where(loading_orders:{sales_man: current_user.employee.id})
    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    
  end

  # POST /sales or /sales.json
  def create
    @sale = Sale.new(sale_params)
    @products = LoadingOrderItem.joins(:loading_order).where(loading_orders:{sales_man: current_user.employee.id})
    @customers = current_territory.customers
    @employees = current_territory.employees
    
    respond_to do |format|
      if @sale.save
        @sale.sale_items.each do |sale_item|
          deduct_quantity(sale_item)
        end
        format.html { redirect_to sales_path, notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    @products = LoadingOrderItem.joins(:loading_order).where(loading_orders:{sales_man: current_user.employee.id})
    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to sales_path, notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy!

    respond_to do |format|
      format.html { redirect_to sales_path, status: :see_other, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sale_pdf
    @sale = Sale.find(params[:id]) 
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "sales/sale_pdf", formats: [:html], disposition: :inline, layout: 'pdf'   # Excluding ".pdf" extension.
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_params
      params.require(:sale).permit(:customer_name, :user_id, :sale_type, :mode_of_payment,:sale_date, :customer_tin,:territory_id, :receipt_no,:status_id, :customer_mobile, :sales_route, :notes,
      sale_items_attributes: [:id,:sale_id, :loading_order_item_id, :quantity_sold, :amount, :total, :_destroy],
      sale_empties_attributes: [:id, :sale_id, :empty_type_id, :expected, :received, :variance, :_destroy])
    end

    def deduct_quantity(sale_item)
      loading_order_item = sale_item.loading_order_item
  
      if loading_order_item.remaining_quantity >= sale_item.quantity_sold
        loading_order_item.remaining_quantity -= sale_item.quantity_sold
        loading_order_item.save!
      else
        raise "Insufficient stock for Loading Order Item ID #{loading_order_item.id}"
      end
    end
end
