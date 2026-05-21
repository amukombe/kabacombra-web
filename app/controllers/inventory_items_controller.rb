class InventoryItemsController < ApplicationController
  before_action :set_inventory_item, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /inventory_items or /inventory_items.json
  def empties
    @territory= Territory.find(current_territory.id)
    today = Date.today.beginning_of_day
    tomorrow = today + 1.day

    @inventory_items = @territory.inventory_transactions
      .joins(:nile_product)
      .select(
        "nile_products.id AS nile_product_id,
        nile_products.name,
        nile_products.selling_price,

        -- Opening stock
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date < '#{today}' AND inventory_transactions.direction = 'in' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        -
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date < '#{today}' AND inventory_transactions.direction = 'out' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        AS opening_stock,

        -- Quantity In Today
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date >= '#{today}' AND inventory_transactions.transaction_date < '#{tomorrow}' AND inventory_transactions.direction = 'in' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        AS quantity_in,

        -- Quantity Out Today
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date >= '#{today}' AND inventory_transactions.transaction_date < '#{tomorrow}' AND inventory_transactions.direction = 'out' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        AS quantity_out
        "
      )
    .group("nile_products.id, nile_products.name, nile_products.selling_price")
    .page(params["page"]).per(10)
    
    @active_link = "empties"
    @warehouses = current_territory.warehouses
  end

  def index_old
    @territory= Territory.find(current_territory.id)
    today = Date.today.beginning_of_day
    tomorrow = today + 1.day

    @inventory_items = @territory.inventory_transactions
      .joins(:nile_product)
      .select(
        "nile_products.id AS nile_product_id,
        nile_products.name,
        nile_products.selling_price,

        -- Opening stock
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date < '#{today}' AND inventory_transactions.direction = 'in' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        -
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date < '#{today}' AND inventory_transactions.direction = 'out' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        AS opening_stock,

        -- Quantity In Today
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date >= '#{today}' AND inventory_transactions.transaction_date < '#{tomorrow}' AND inventory_transactions.direction = 'in' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        AS quantity_in,

        -- Quantity Out Today
        COALESCE(SUM(CASE WHEN inventory_transactions.transaction_date >= '#{today}' AND inventory_transactions.transaction_date < '#{tomorrow}' AND inventory_transactions.direction = 'out' THEN inventory_transactions.transaction_quantity ELSE 0 END), 0)
        AS quantity_out
        "
      )
    .group("nile_products.id, nile_products.name, nile_products.selling_price")
    .order("nile_products.product_number ASC")
    .page(params["page"]).per(10)
    
    @active_link = "purchases"
    @active_sub_link = "purchases"
    @warehouses = current_territory.warehouses
  end

  def index
    @territory = Territory.find(current_territory.id)

    # Date filters
    start_date =
      params[:start_date].present? ?
        Date.parse(params[:start_date]).beginning_of_day :
        Date.today.beginning_of_day

    end_date =
      params[:end_date].present? ?
        Date.parse(params[:end_date]).end_of_day :
        Date.today.end_of_day

    @inventory_items = NileProduct
      .left_joins(:inventory_transactions)
      .includes(:empty_type)
      .select(
        "
        nile_products.*,

        -- Opening Stock
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date < '#{start_date}'
              AND inventory_transactions.direction = 'in'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        )
        -
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date < '#{start_date}'
              AND inventory_transactions.direction = 'out'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        ) AS opening_stock,

        -- Quantity In
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date >= '#{start_date}'
              AND inventory_transactions.transaction_date <= '#{end_date}'
              AND inventory_transactions.direction = 'in'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        ) AS quantity_in,

        -- Quantity Out
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date >= '#{start_date}'
              AND inventory_transactions.transaction_date <= '#{end_date}'
              AND inventory_transactions.direction = 'out'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        ) AS quantity_out
        "
      )

    # Optional search
    if params[:query].present?
      @inventory_items = @inventory_items.where(
        "nile_products.name LIKE ?",
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"
      )
    end

    @inventory_items = @inventory_items
      .group("nile_products.id")
      .order("nile_products.product_number ASC")
      .page(params[:page])
      .per(20)

    @active_link = "purchases"
    @active_sub_link = "purchases"
  end

  def export
    @territory = Territory.find(current_territory.id)

    # Date filters
    start_date =
      params[:start_date].present? ?
        Date.parse(params[:start_date]).beginning_of_day :
        Date.today.beginning_of_day

    end_date =
      params[:end_date].present? ?
        Date.parse(params[:end_date]).end_of_day :
        Date.today.end_of_day

    @inventory_items = NileProduct
      .left_joins(:inventory_transactions)
      .includes(:empty_type)
      .select(
        "
        nile_products.*,

        -- Opening Stock
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date < '#{start_date}'
              AND inventory_transactions.direction = 'in'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        )
        -
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date < '#{start_date}'
              AND inventory_transactions.direction = 'out'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        ) AS opening_stock,

        -- Quantity In
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date >= '#{start_date}'
              AND inventory_transactions.transaction_date <= '#{end_date}'
              AND inventory_transactions.direction = 'in'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        ) AS quantity_in,

        -- Quantity Out
        COALESCE(
          SUM(
            CASE
              WHEN inventory_transactions.territory_id = #{current_territory.id}
              AND inventory_transactions.transaction_date >= '#{start_date}'
              AND inventory_transactions.transaction_date <= '#{end_date}'
              AND inventory_transactions.direction = 'out'
              THEN inventory_transactions.transaction_quantity
              ELSE 0
            END
          ), 0
        ) AS quantity_out
        "
      )

    # Same search as index
    if params[:query].present?
      @inventory_items = @inventory_items.where(
        "nile_products.name LIKE ?",
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"
      )
    end

    # Same grouping/order as index (NO pagination)
    @inventory_items = @inventory_items
      .group("nile_products.id")
      .order("nile_products.product_number ASC")

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Inventory Summary") do |sheet|
      sheet.add_row [
        "Product",
        "Opening Stock",
        "Quantity In",
        "Quantity Out",
        "Closing Stock",
        "Beer Value",
        "Empty Value",
        "Closing Stock Value"
      ]

      @inventory_items.each do |item|
        closing_stock =
          item.opening_stock.to_i +
          item.quantity_in.to_i -
          item.quantity_out.to_i

        beer_value = closing_stock * item.buying_price.to_i
        empty_value = closing_stock * item.empty_type&.price.to_i
        closing_stock_value = closing_stock * item.buying_price.to_i

        sheet.add_row [
          item.name,
          item.opening_stock.to_i,
          item.quantity_in.to_i,
          item.quantity_out.to_i,
          closing_stock,
          beer_value,
          empty_value,
          closing_stock_value
        ]
      end
    end

    send_data(
      package.to_stream.read,
      filename: "inventory_summary_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  def received_stock
    @active_link = "purchases"
    @active_sub_link = "received"
    @warehouses = current_territory.warehouses

    @inventory_items = InventoryItem
      .product_summary(params,current_territory.id)
      .page(params[:page])
      .per(20)
  end
  def export_received_stock
    @inventory_items = InventoryItem.product_summary(
      params,
      current_territory.id
    )

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Received Stock Summary") do |sheet|
      sheet.add_row [
        "Product",
        "Received Qty",
        "Shortages",
        "Complaints",
        "Total Load"
      ]

      @inventory_items.each do |item|
        sheet.add_row [
          item.product_name,
          item.total_received.to_i,
          item.total_breakages.to_i,
          item.total_complaints.to_i,
          item.total_quantity.to_i
        ]
      end
    end

    send_data(
      package.to_stream.read,
      filename: "received_stock_summary_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  def warehouses_overview
    @territory = current_territory

    today = Date.today.beginning_of_day
    tomorrow = today + 1.day

    @warehouses = @territory.warehouses

    @warehouse_stats = @warehouses.map do |store|

      base_query = @territory.inventory_transactions
        .joins(:nile_product)
        .joins("LEFT JOIN inventory_items ON inventory_items.nile_product_id = inventory_transactions.nile_product_id")
        .joins("INNER JOIN inventory_item_stores ON inventory_item_stores.inventory_item_id = inventory_items.id")
        .where("inventory_item_stores.store_id = ?", store.id)

      summary = base_query.select(
        "COUNT(DISTINCT nile_products.id) AS total_products",

        "COALESCE(SUM(CASE WHEN direction = 'in' THEN transaction_quantity ELSE 0 END), 0)
        -
        COALESCE(SUM(CASE WHEN direction = 'out' THEN transaction_quantity ELSE 0 END), 0)
        AS total_stock",

        "COALESCE(SUM(
          (
            CASE WHEN direction = 'in' THEN transaction_quantity ELSE 0 END
            -
            CASE WHEN direction = 'out' THEN transaction_quantity ELSE 0 END
          ) * nile_products.selling_price
        ), 0) AS stock_value",

        "COALESCE(SUM(CASE WHEN transaction_date >= '#{today}' AND transaction_date < '#{tomorrow}' AND direction = 'in'
        THEN transaction_quantity ELSE 0 END), 0) AS today_in",

        "COALESCE(SUM(CASE WHEN transaction_date >= '#{today}' AND transaction_date < '#{tomorrow}' AND direction = 'out'
        THEN transaction_quantity ELSE 0 END), 0) AS today_out"
      ).take

      {
        store: store,
        total_products: summary.total_products,
        total_stock: summary.total_stock.to_i,
        stock_value: summary.stock_value.to_i,
        today_in: summary.today_in.to_i,
        today_out: summary.today_out.to_i
      }
    end
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
