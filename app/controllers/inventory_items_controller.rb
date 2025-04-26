class InventoryItemsController < ApplicationController
  before_action :set_inventory_item, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /inventory_items or /inventory_items.json
  def index
    @inventory_items = InventoryItem.search(params, current_territory.id).page(params[:page]).per(20)
    @active_link = "purchases"
    @warehouses = Store.all
  end

  # GET /inventory_items/1 or /inventory_items/1.json
  def show
  end

  # GET /inventory_items/new
  def new
    @inventory_item = InventoryItem.new
  end

  # GET /inventory_items/1/edit
  def edit
  end

  # POST /inventory_items or /inventory_items.json
  def create
    @inventory_item = InventoryItem.new(inventory_item_params)

    respond_to do |format|
      if @inventory_item.save
        format.html { redirect_to @inventory_item, notice: "Inventory item was successfully created." }
        format.json { render :show, status: :created, location: @inventory_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_items/1 or /inventory_items/1.json
  def update
    respond_to do |format|
      if @inventory_item.update(inventory_item_params)
        format.html { redirect_to @inventory_item, notice: "Inventory item was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_items/1 or /inventory_items/1.json
  def destroy
    @inventory_item.destroy!

    respond_to do |format|
      format.html { redirect_to inventory_items_path, status: :see_other, notice: "Inventory item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_store
    @inventory_item = InventoryItem.find(params[:id])
    @stores = Store.where(territory_id: current_territory.id)
    @inventory_item_store = @inventory_item.inventory_item_stores.build
  end

  def update_store
    puts "ID:========#{params[:id]}"
    @inventory_item = InventoryItem.find(params[:id])
    @inventory_item_store = @inventory_item.inventory_item_stores.build(inventory_item_store_params)
    @stores = Store.where(territory_id: current_territory.id)
    if @inventory_item_store.save
      redirect_to inventory_items_path, notice: "Driver assigned successfully."
    else
      @stores = Store.where(territory_id: current_territory.id)
      flash.now[:alert] = "Failed to assign driver."
      render :assign_department, status: :unprocessable_entity
    end
  end

  def remove_store
    @order_driver = OrderDriver.find(params[:id])
    @driver = Driver.find(@order_driver.driver.id)
    @order = Order.find(@order_driver.order.id)
    if @order_driver.destroy
      @order.update(status_id: 1)
      @driver.update(is_available: true)
      respond_to do |format|
        format.html { redirect_to orders_path, notice: "Driver successfully removed." }
        format.js   # If you want to handle it via JavaScript
      end
    else
      respond_to do |format|
        format.html { redirect_to orders_path, alert: "Failed to remove driver." }
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_item
      @inventory_item = InventoryItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inventory_item_params
      params.require(:inventory_item).permit(:inventory_id, :nile_product_id, :quantity_ordered, :quantity_dispatched, :quantity_received, :quantity_sold, :purchase_price, :selling_price, :is_active, :is_closed, :is_deleted, :user_id, :manufacture_date, :expiry_date, :delivery_time)
    end

    def inventory_item_store_params
      params.require(:inventory_item_store).permit(:inventory_item_id, :store_id)
    end
end
