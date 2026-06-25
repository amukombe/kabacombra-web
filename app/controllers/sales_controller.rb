class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy ]

  # GET /sales or /sales.json
  def index
    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= Date.current.to_s
    @sales = Sale.search(params).page(params[:page]).per(20)
    @active_link = "sales"
  end

  def sales_summary
    @active_link = "sales"

    @stores = current_territory.stores.order(:name)

    @products = NileProduct
      .order(:product_number)
      .page(params[:page])
      .per(20)

    if params[:query].present?
      @products = @products.where(
        "name LIKE ?",
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"
      )
    end

    query = SaleItem
      .joins(:sale)
      .where(
        sales: {
          territory_id: current_territory.id
        }
      )

    # Default to today if no dates selected
    if params[:start_date].blank? && params[:end_date].blank?
      query = query.where(
        "DATE(sales.sale_date) = ?",
        Date.current
      )
    else
      if params[:start_date].present?
        query = query.where(
          "DATE(sales.sale_date) >= ?",
          params[:start_date]
        )
      end

      if params[:end_date].present?
        query = query.where(
          "DATE(sales.sale_date) <= ?",
          params[:end_date]
        )
      end
    end

    raw_data = query
      .group(
        :nile_product_id,
        "sales.store_id"
      )
      .sum(:quantity_sold)

    @report_data = {}

    raw_data.each do |(product_id, store_id), quantity|
      @report_data[product_id] ||= {}
      @report_data[product_id][store_id] = quantity
    end
  end

  # GET /sales/1 or /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @active_link = "pending"

    @order = LoadingOrder.find(params[:id])

    @sale = Sale.new(
      sale_date: DateTime.current,
      store_id: @order.store_id
    )

    @order.loading_order_items.each do |loading_item|
      quantity = loading_item.remaining_quantity || loading_item.quantity_loaded

      next if quantity <= 0

      @sale.sale_items.build(
        loading_order_item_id: loading_item.id,
        nile_product_id: loading_item.nile_product_id,
        quantity_sold: quantity,
        amount: loading_item.nile_product.selling_price,
        total: quantity * loading_item.nile_product.selling_price.to_i
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
      .select(
        'nile_product_id,
        nile_products.id,
        nile_products.name,
        SUM(loading_order_items.remaining_quantity) AS total_quantity'
      )

    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    @purchase_types = PurchaseType.all
  end

  # POST /sales
  def create
    create_customer_if_needed

    @sale = Sale.new(sale_params)

    @products = LoadingOrderItem
      .joins(:loading_order)
      .where(loading_orders: { sales_man: current_user.employee.id })

    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    @purchase_types = PurchaseType.all

    respond_to do |format|
      if @sale.save
        format.html do
          redirect_to sales_path,
                      notice: "Sale was successfully created."
        end

        format.json do
          render :show,
                status: :created,
                location: @sale
        end
      else
        first_item = @sale.sale_items.first

        if first_item&.loading_order_item.present?
          @order = first_item.loading_order_item.loading_order
          @sale_items = @order.loading_order_items
        end

        format.html do
          render :new,
                status: :unprocessable_entity
        end

        format.json do
          render json: @sale.errors,
                status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /sales/1
  def update
    @products = LoadingOrderItem
      .joins(:loading_order)
      .where(loading_orders: { sales_man: current_user.employee.id })

    @customers = current_territory.customers
    @employees = current_territory.employees
    @empties = EmptyType.all
    @purchase_types = PurchaseType.all

    respond_to do |format|
      if @sale.update(sale_params)
        format.html do
          redirect_to sales_path,
                      notice: "Sale was successfully updated."
        end

        format.json do
          render :show,
                status: :ok,
                location: @sale
        end
      else
        format.html do
          render :edit,
                status: :unprocessable_entity
        end

        format.json do
          render json: @sale.errors,
                status: :unprocessable_entity
        end
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
    def create_customer_if_needed
      return if params[:sale][:customer_id].present?

      customer = Customer.create!(
        name: params[:sale][:customer_name],
        mobile: params[:sale][:customer_mobile],
        brn: params[:sale][:tin],
        territory_id: current_territory.id
      )

      params[:sale][:customer_id] = customer.id
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_params
      params.require(:sale).permit(:customer_id, :customer_name, :user_id, :mode_of_payment,:sale_date, :tin,:territory_id, :receipt_no,:status_id, :customer_mobile, :sales_route, :store_id, :notes,:payment_ref, :fdn, :invoice_no,
      sale_items_attributes: [:id,:sale_id, :loading_order_item_id, :nile_product_id, :purchase_type_id, :quantity_sold, :amount, :total, :_destroy],
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
