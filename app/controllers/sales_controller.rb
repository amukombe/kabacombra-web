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
    @active_link = "pending"

    @order = LoadingOrder.find_by(id: params[:id])
    @sale = Sale.new(sale_date: DateTime.now)
    # building items
    @order.loading_order_items.each do |loading_item|
      @sale.sale_items.build(
        id: loading_item.id,
        quantity_sold: loading_item.quantity_loaded,
        amount: loading_item.nile_product.buying_price,
        total: loading_item.quantity_loaded.to_i * loading_item.nile_product.buying_price.to_i
      )
    end

    @customers = current_territory.customers
    @employees = current_territory.employees
    @sale_items = @order.loading_order_items
    @purchase_types = PurchaseType.all

  end

  # GET /sales/1/edit
  def edit
    @products = LoadingOrderItem
      .joins(:loading_order, :nile_product)
      .where(loading_orders: { sales_man: current_user.employee.id })
      .group('nile_products.id', 'nile_products.name')
      .select('nile_product_id, nile_products.id, nile_products.name, SUM(loading_order_items.quantity_loaded) AS total_quantity')

    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    @purchase_types = PurchaseType.all
    
  end

  # POST /sales or /sales.json
  def create
    @sale = Sale.new(sale_params)
    @products = LoadingOrderItem.joins(:loading_order).where(loading_orders:{sales_man: current_user.employee.id})
    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    @purchase_types = PurchaseType.all
    respond_to do |format|
      if @sale.save
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
    @purchase_types = PurchaseType.all
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

  #my sales approvals
  def approvals
    @active_link = "approvals"
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
      params.require(:sale).permit(:customer_name, :user_id, :mode_of_payment,:sale_date, :tin,:territory_id, :receipt_no,:status_id, :customer_mobile, :sales_route, :store_id, :notes,:payment_ref,
      sale_items_attributes: [:id,:sale_id, :nile_product_id, :purchase_type_id, :quantity_sold, :amount, :total, :_destroy],
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
