class LoadingOrdersController < ApplicationController
  before_action :set_loading_order, only: %i[ show edit update destroy ]

  # GET /loading_orders or /loading_orders.json
  def index
    @active_link = "loading_orders"
    @loading_orders = LoadingOrder.search(params, current_territory.id).page(params[:page]).per(20)
  end

  # GET /loading_orders/1 or /loading_orders/1.json
  def show
  end

  # GET /loading_orders/new
  def new
    @loading_order = LoadingOrder.new
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
    @loading_order.loading_order_items.build
  end

  # GET /loading_orders/1/edit
  def edit
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
  end

  # POST /loading_orders or /loading_orders.json
  def create
    @loading_order = LoadingOrder.new(loading_order_params)
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
    respond_to do |format|
      if @loading_order.save
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
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    @employees = current_territory.employees
    @sale_types = SaleType.all
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
    @loading_order.destroy!

    respond_to do |format|
      format.html { redirect_to loading_orders_path, status: :see_other, notice: "Loading order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def  approvals
    @active_link = "approvals"
    status_id = 6
    @loading_orders = LoadingOrder.my_approvals(params, current_territory.id, current_user.id, status_id).page(params[:page]).per(20)
  end

  def approve
    @order = LoadingOrder.find(params[:id])
    @order.update(status_id: 7)
    redirect_to approvals_path, notice: "Loading order approved"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loading_order
      @loading_order = LoadingOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loading_order_params
      params.require(:loading_order).permit(:driver_name, :user_id, :territory_id, :status_id, :vehicle_numperplate, :destination, :loading_date, :order_number, :sales_man, :authorized_by, :verified_by, :sale_type_id,
      loading_order_items_attributes: [:id, :loading_order_id, :nile_product_id, :quantity_loaded, :_destroy ])
    end
end
