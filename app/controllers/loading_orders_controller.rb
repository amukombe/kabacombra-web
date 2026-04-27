class LoadingOrdersController < ApplicationController
  before_action :set_loading_order, only: %i[ show edit update destroy ]

  # GET /loading_orders or /loading_orders.json
  def index
    @active_link = "loading_orders"
    @loading_orders = LoadingOrder.search(params, current_territory.id).order(created_at: :desc).page(params[:page]).per(20)
  end

  # GET /loading_orders/1 or /loading_orders/1.json
  def show
  end

  # GET /loading_orders/new
  def new
    @active_link = "loading_orders"
    @loading_order = LoadingOrder.new
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
    @stores = Store.where(territory_id: current_territory.id)
    @loading_order.loading_order_items.build
  end

  # GET /loading_orders/1/edit
  def edit
    @active_link = "loading_orders"
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
    @stores = Store.where(territory_id: current_territory.id)
  end

  # POST /loading_orders or /loading_orders.json
  def create
    @active_link = "loading_orders"
    @loading_order = LoadingOrder.new(loading_order_params)
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
    @stores = Store.where(territory_id: current_territory.id)
    respond_to do |format|
      if @loading_order.save
        @loading_order.loading_order_items.each do |item|
          InventoryAllocator.new(item.nile_product, item.quantity_loaded, current_territory.id).allocate
        end
        format.html { redirect_to loading_orders_path, notice: "Loading order was successfully created." }
        format.json { render :show, status: :created, location: @loading_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loading_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loading_orders/1 or /loading_orders/1.json
  def update
    @active_link = "loading_orders"
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
    @stores = Store.where(territory_id: current_territory.id)
    respond_to do |format|
      if @loading_order.update(loading_order_params)
        format.html { redirect_to loading_orders_path, notice: "Loading order was successfully updated." }
        format.json { render :show, status: :ok, location: @loading_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loading_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loading_orders/1 or /loading_orders/1.json
  def destroy
    LoadingOrder.transaction do
      deallocate_inventory(@loading_order) # Call the deallocation logic
      @loading_order.destroy! # Destroy the loading order record
    end
    #@loading_order.destroy!

    respond_to do |format|
      format.html { redirect_to loading_orders_path, status: :see_other, notice: "Loading order was successfully destroyed." }
      format.json { head :no_content }
    end
  end



  def  approvals
    @active_link = "approvals"
    status_id = 6
    @loading_orders = LoadingOrder.my_approvals(params, current_territory.id, current_user.employee.id, status_id).page(params[:page]).per(20)
  end

  def approve
    @order = LoadingOrder.find(params[:id])
    @order.update(status_id: 7)
    redirect_to approvals_path, notice: "Loading order approved"
  end

  def store_inventory
    @active_link='store_inventory'
    sales_man = current_user.id
    #@products = LoadingOrderItems.
    @loading_orders = LoadingOrder.where(sales_man: sales_man).order(loading_date: :desc).page(params[:page]).per(20)
  end

  def store_loading_orders
    @active_link='loading_orders'
    sales_man = current_user.id
    @loading_orders = LoadingOrder.where(sales_man: sales_man).order(loading_date: :desc).page(params[:page]).per(20)
  end

  private

    def deallocate_inventory(loading_order)
      loading_order.loading_order_items.each do |loading_order_item|
        InventoryAllocator.new(loading_order_item.nile_product,loading_order_item.quantity_loaded,loading_order.territory_id).deallocate # Perform reverse allocation for each item
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_loading_order
      @loading_order = LoadingOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loading_order_params
      params.require(:loading_order).permit(:driver_name, :user_id, :territory_id, :status_id, :vehicle_numperplate, :loading_date, :sales_man, :authorized_by, :sale_type_id,:store_id,
      loading_order_items_attributes: [:id, :loading_order_id, :nile_product_id, :quantity_loaded, :_destroy ])
    end
end
