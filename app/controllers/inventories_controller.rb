class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /inventories or /inventories.json
  def index
    @inventories = Inventory.all
  end

  # GET /inventories/1 or /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @dispatch = BeerDispatch.find(params[:id])
    @inventory = Inventory.new(delivery_time: Time.now)
    # Build dispatch items based on existing order items
    @dispatch.dispatch_items.each do |item|
      @inventory.inventory_items.build(
        dispatch_item_id: item.id, 
        quantity_dispatched: item.quantity_dispatched,
        quantity_received: item.quantity_dispatched,
        purchase_price: item.order_item.unit_price,
        selling_price: item.order_item.nile_product.selling_price
      )
    end
    @dispatch_items = @dispatch.dispatch_items
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories or /inventories.json
  def create
    dispatch_id = inventory_params[:beer_dispatch_id]
    @dispatch = BeerDispatch.find(dispatch_id)
    @inventory = Inventory.new(inventory_params)
    @dispatch_items = @dispatch.dispatch_items
    respond_to do |format|
      if @inventory.save
        @dispatch.order.update(status_id: 4)
        format.html { redirect_to beer_dispatches_path, notice: "Inventory was successfully created." }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1 or /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to beer_dispatches_path, notice: "Inventory was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  #Additional method for inventory not coming from dispatches
  def existing_stock
    @inventory = Inventory.new
    @inventory.inventory_items.build
    @nile_products = NileProduct.all
  end
  def create_existing_stock
    @inventory = Inventory.new(existing_stock_params)
    @inventory.user_id = current_user.id # Optional: Set user if not in form

    if @inventory.save
      redirect_to @inventory, notice: "Existing stock added successfully."
    else
      @nile_products = NileProduct.all
      render :existing_stock, status: :unprocessable_entity
    end
  end

  # DELETE /inventories/1 or /inventories/1.json
  def destroy
    @inventory.destroy!

    respond_to do |format|
      format.html { redirect_to inventories_path, status: :see_other, notice: "Inventory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inventory_params
      params.require(:inventory).permit(:beer_dispatch_id, :total,:delivery_time,:user_id,:territory_id, 
      inventory_items_attributes: [:id, :inventory_id,:nile_product_id, :dispatch_item_id, :quantity_ordered, :quantity_dispatched, :quantity_received, :quantity_sold, :purchase_price, :selling_price, :is_active, :is_closed, :is_deleted, :manufacture_date, :expiry_date, :breakages, :missing_bottles, :complaints, :_destroy])
    end

    def existing_stock_params
      params.require(:inventory).permit(:total,:delivery_time,:user_id,:territory_id, 
      inventory_items_attributes: [:id, :inventory_id,:nile_product_id, :quantity_ordered, :quantity_dispatched, :quantity_received, :quantity_sold, :purchase_price, :selling_price, :is_active, :is_closed, :is_deleted, :manufacture_date, :expiry_date, :breakages, :missing_bottles, :complaints, :_destroy])
    end
end
