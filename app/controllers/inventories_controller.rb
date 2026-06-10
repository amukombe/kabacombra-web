class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /inventories or /inventories.json
  def index
    @active_link = "received"
    @inventories = Inventory.search(params, current_territory.id).page(params[:page]).per(20)
  end

  def export
    @inventories = Inventory
                    .search(params, current_territory.id)
                    .includes(
                      :warehouse,
                      beer_dispatch: :order,
                      inventory_items: :nile_product
                    )

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Inventories") do |sheet|
      sheet.add_row [
        "Date",
        "Order Number",
        "Invoice No",
        "FDN Number",
        "Dispatch No",
        "Truck Number",
        "Driver Name",
        "Warehouse",
        "Product",
        "Qty Received",
        "Shortages",
        "Complaints",
        "Total Qty",
        "Rate",
        "Beer Value",
        "Case Value",
        "Purchase Value"
      ]

      @inventories.each do |inventory|
        dispatch = inventory.beer_dispatch
        order = dispatch&.order
        warehouse = inventory.warehouse

        inventory.inventory_items.each do |item|
          sheet.add_row [
            inventory.delivery_time&.strftime("%d-%b-%Y"),
            order&.order_number,
            dispatch&.invoice_no,
            dispatch&.fdn_number,
            dispatch&.dispatch_no,
            dispatch&.truck_numberplate,
            dispatch&.driver_name,
            warehouse&.name,
            item.nile_product&.name,
            item.quantity_received,
            item.breakages,
            item.complaints,
            item.total_quantity,
            item.purchase_price,
            item.total,
            item.total_case,
            item.total_Purchase
          ]
        end

        # Totals row per inventory
        sheet.add_row [
          nil, nil, nil, nil, nil, nil, nil, nil,
          "TOTAL",
          nil, nil, nil, nil, nil,
          inventory.total_price,
          inventory.total_case,
          inventory.total_Purchase
        ]
      end
    end

    send_data(
      package.to_stream.read,
      filename: "inventories_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  def received_stock_details
    @active_link = "purchases"
    @active_sub_link = "received"
    @inventories = Inventory.search_received(params, current_territory.id).page(params[:page]).per(20)
  end

  def export_received_stock_details
    @inventories = Inventory
                    .search_received(params, current_territory.id)
                    .includes(
                      :warehouse,
                      beer_dispatch: :order,
                      inventory_items: :nile_product
                    )

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Received Stock Details") do |sheet|
      sheet.add_row [
        "Date",
        "Order Number",
        "Invoice No",
        "FDN Number",
        "Dispatch No",
        "Truck Number",
        "Driver Name",
        "Warehouse",
        "Product",
        "Qty Received",
        "Shortages",
        "Complaints",
        "Total Qty"
      ]

      @inventories.each do |inventory|
        dispatch = inventory.beer_dispatch
        order = dispatch&.order
        warehouse = inventory.warehouse

        inventory.inventory_items.each do |item|
          sheet.add_row [
            inventory.delivery_time&.strftime("%d-%b-%Y"),
            order&.order_number,
            dispatch&.invoice_no,
            dispatch&.fdn_number,
            dispatch&.dispatch_no,
            dispatch&.truck_numberplate,
            dispatch&.driver_name,
            warehouse&.name,
            item.nile_product&.name,
            item.quantity_received,
            item.breakages,
            item.complaints,
            item.total_quantity
          ]
        end
      end
    end

    send_data(
      package.to_stream.read,
      filename: "received_stock_details_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  def receive
    @inventory = Inventory.find(params[:id])
    @beer_dispatch = @inventory.beer_dispatch
    @order = @inventory.beer_dispatch.order
    if @beer_dispatch.update(status_id: 13) # Update beer dispatch status to "Received"
      @order.update(status_id: 13) # Update order status to "Completed"
      @inventory.update(status_id: 13) # Update inventory status to "Received"
      redirect_to received_stock_inventory_items_path, notice: "Inventory received successfully"
    else
      redirect_to received_stock_inventory_items_path, alert: "Failed to update inventory"
    end
  end

  # GET /inventories/1 or /inventories/1.json
  def show
    @dispatch = BeerDispatch.find(@inventory.beer_dispatch_id)
    @inventory = Inventory.new(delivery_time: Time.now)
    @warehouses = current_territory.warehouses
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

  # GET /inventories/new
  def new
    @dispatch = BeerDispatch.find(params[:id])
    @inventory = Inventory.new(delivery_time: Time.now)
    @warehouses = current_territory.warehouses
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
    @dispatch = BeerDispatch.find(@inventory.beer_dispatch_id)
    @inventory = Inventory.new(delivery_time: Time.now)
    @warehouses = current_territory.warehouses
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

  # POST /inventories or /inventories.json
  def create
    dispatch_id = inventory_params[:beer_dispatch_id]
    @dispatch = BeerDispatch.find(dispatch_id)
    @warehouses = current_territory.warehouses
    @inventory = Inventory.new(inventory_params)
    @inventory.status_id = 4 # Set inventory status to "Received"
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
    dispatch_id = inventory_params[:beer_dispatch_id]
    @dispatch = BeerDispatch.find(dispatch_id)
    @warehouses = current_territory.warehouses
    @inventory = Inventory.new(inventory_params)
    @dispatch_items = @dispatch.dispatch_items
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to inventories_path, notice: "Inventory was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  #Additional method for inventory not coming from dispatches
  def existing_stock
    @active_link = "opening_stock"
    @inventory = Inventory.new
    @inventory.inventory_items.build
    @nile_products = NileProduct.all
    @warehouses = current_territory.warehouses
  end
  def create_existing_stock
    @active_link = "opening_stock"
    @inventory = Inventory.new(existing_stock_params)
    @inventory.user_id = current_user.id # Optional: Set user if not in form
    @inventory.territory_id = current_territory.id
    @warehouses = current_territory.warehouses

    if @inventory.save
      redirect_to inventory_items_path, notice: "Existing stock added successfully."
    else
      @nile_products = NileProduct.all
      render :existing_stock, status: :unprocessable_entity
    end
  end

  # DELETE /inventories/1 or /inventories/1.json
  def destroy
    @beer_dispatch = @inventory.beer_dispatch
    @beer_dispatch&.order&.update(status_id: 3)

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
      params.require(:inventory).permit(:warehouse_id, :beer_dispatch_id, :total,:delivery_time,:user_id,:territory_id, 
      inventory_items_attributes: [:id, :inventory_id,:nile_product_id, :dispatch_item_id, :quantity_ordered, :quantity_dispatched, :quantity_received, :quantity_sold, :purchase_price, :selling_price, :is_active, :is_closed, :is_deleted, :manufacture_date, :expiry_date, :breakages, :missing_bottles, :complaints, :_destroy])
    end

    def existing_stock_params
      params.require(:inventory).permit(:warehouse_id,:total,:delivery_time, 
      inventory_items_attributes: [:id, :inventory_id,:nile_product_id,:good_beer, :quantity_sold, :purchase_price, :selling_price, :is_active, :is_closed, :is_deleted, :manufacture_date, :expiry_date, :breakages, :bad_beer, :complaints, :_destroy])
    end
end

