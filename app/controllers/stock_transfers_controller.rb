class StockTransfersController < ApplicationController
  before_action :set_stock_transfer, only: %i[ show edit update destroy ]

  # GET /stock_transfers or /stock_transfers.json
  def index
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @stock_transfers = StockTransfer.search(params, current_territory.id).order(created_at: :desc).page(params[:page]).per(20)
  end

  def export
    @stock_transfers = StockTransfer
                        .search(params, current_territory.id)
                        .order(created_at: :desc)
                        .includes(
                          :source,
                          :destination,
                          stock_transfer_items: :nile_product
                        )

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Stock Transfers") do |sheet|
      sheet.add_row [
        "Transfer Date",
        "Transfer Type",
        "Description",
        "From",
        "To",
        "Product",
        "Quantity",
        "Status"
      ]

      @stock_transfers.each do |transfer|
        from_location =
          case transfer.transfer_type
          when "branch_transfer"
            transfer.source&.name
          when "store_transfer"
            transfer.source&.name
          when "warehouse_transfer"
            "Warehouse"
          when "distributor_transfer"
            transfer.from_distributor
          else
            "-"
          end

        to_location =
          case transfer.transfer_type
          when "branch_transfer"
            transfer.destination&.name
          when "store_transfer"
            transfer.destination&.name
          when "warehouse_transfer"
            "Warehouse"
          when "distributor_transfer"
            transfer.to_distributor
          else
            "-"
          end

        transfer.stock_transfer_items.each do |item|
          sheet.add_row [
            transfer.transfer_date&.strftime("%d-%b-%Y"),
            transfer.transfer_type&.humanize,
            transfer.description,
            from_location,
            to_location,
            item.nile_product&.name,
            item.transfer_quantity,
            transfer.status
          ]
        end
      end
    end

    send_data(
      package.to_stream.read,
      filename: "stock_transfers_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  def transfer_summary
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"

    territory_id = current_territory.id

    query = NileProduct
              .left_joins(stock_transfer_items: :stock_transfer)

    # Search
    if params[:query].present?
      query = query.where(
        "nile_products.name LIKE ?",
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"
      )
    end

    # Relevant transfers
    query = query.where(
      "
        stock_transfers.territory_id = :territory
        OR stock_transfers.source_id = :territory
        OR stock_transfers.destination_id = :territory
        OR stock_transfers.id IS NULL
      ",
      territory: territory_id
    )

    # Date filters
    if params[:start_date].present?
      query = query.where(
        "stock_transfers.transfer_date >= ? OR stock_transfers.id IS NULL",
        params[:start_date]
      )
    end

    if params[:end_date].present?
      query = query.where(
        "stock_transfers.transfer_date <= ? OR stock_transfers.id IS NULL",
        params[:end_date]
      )
    end

    @transfer_items = query
      .joins(
        "LEFT JOIN territories source_territories
        ON source_territories.id = stock_transfers.source_id"
      )
      .joins(
        "LEFT JOIN territories destination_territories
        ON destination_territories.id = stock_transfers.destination_id"
      )
      .joins(
        "LEFT JOIN stores source_stores
        ON source_stores.id = stock_transfers.source_id"
      )
      .joins(
        "LEFT JOIN stores destination_stores
        ON destination_stores.id = stock_transfers.destination_id"
      )
      .group(
        "nile_products.id,
        nile_products.name,
        stock_transfers.id,
        stock_transfers.transfer_type,
        source_territories.name,
        destination_territories.name,
        source_stores.name,
        destination_stores.name"
      )
      .select(
        "
        nile_products.id,
        nile_products.name AS product_name,
        stock_transfers.transfer_type,

        CASE
          -- Branch transfer
          WHEN stock_transfers.transfer_type = 'branch_transfer'
            THEN CONCAT(
              'From ',
              COALESCE(source_territories.name, '-'),
              ' to ',
              COALESCE(destination_territories.name, '-')
            )

          -- Store transfer
          WHEN stock_transfers.transfer_type = 'store_transfer'
            THEN CONCAT(
              'From ',
              COALESCE(source_stores.name, '-'),
              ' to ',
              COALESCE(destination_stores.name, '-')
            )

          -- Warehouse transfer
          WHEN stock_transfers.transfer_type = 'warehouse_transfer'
            THEN 'From Warehouse to Warehouse'

          -- Distributor transfer
          WHEN stock_transfers.transfer_type = 'distributor_transfer'
            THEN 'From Distributor'

          ELSE '-'
        END AS transfer_description,

        -- Inward
        SUM(
          CASE
            WHEN stock_transfers.destination_id = #{territory_id}
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            WHEN stock_transfers.transfer_type = 'distributor_transfer'
              AND stock_transfers.territory_id = #{territory_id}
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            WHEN stock_transfers.transfer_type = 'warehouse_transfer'
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            ELSE 0
          END
        ) AS inward_quantity,

        -- Outward
        SUM(
          CASE
            WHEN stock_transfers.source_id = #{territory_id}
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            WHEN stock_transfers.transfer_type = 'warehouse_transfer'
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            ELSE 0
          END
        ) AS outward_quantity,

        -- Total
        SUM(
          COALESCE(stock_transfer_items.transfer_quantity, 0)
        ) AS total_quantity
        "
      )
      .order("nile_products.product_number ASC")
      .page(params[:page])
      .per(20)
  end

  def export_transfer_summary
    territory_id = current_territory.id

    query = NileProduct
              .left_joins(stock_transfer_items: :stock_transfer)

    # Search
    if params[:query].present?
      query = query.where(
        "nile_products.name LIKE ?",
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"
      )
    end

    # Relevant transfers
    query = query.where(
      "
        stock_transfers.territory_id = :territory
        OR stock_transfers.source_id = :territory
        OR stock_transfers.destination_id = :territory
        OR stock_transfers.id IS NULL
      ",
      territory: territory_id
    )

    # Start date
    if params[:start_date].present?
      query = query.where(
        "stock_transfers.transfer_date >= ? OR stock_transfers.id IS NULL",
        params[:start_date]
      )
    end

    # End date
    if params[:end_date].present?
      query = query.where(
        "stock_transfers.transfer_date <= ? OR stock_transfers.id IS NULL",
        params[:end_date]
      )
    end

    @transfer_items = query
      .joins(
        "LEFT JOIN territories source_territories
        ON source_territories.id = stock_transfers.source_id"
      )
      .joins(
        "LEFT JOIN territories destination_territories
        ON destination_territories.id = stock_transfers.destination_id"
      )
      .joins(
        "LEFT JOIN stores source_stores
        ON source_stores.id = stock_transfers.source_id"
      )
      .joins(
        "LEFT JOIN stores destination_stores
        ON destination_stores.id = stock_transfers.destination_id"
      )
      .group(
        "nile_products.id,
        nile_products.name,
        stock_transfers.id,
        stock_transfers.transfer_type,
        source_territories.name,
        destination_territories.name,
        source_stores.name,
        destination_stores.name"
      )
      .select(
        "
        nile_products.id,
        nile_products.name AS product_name,
        stock_transfers.transfer_type,

        CASE
          WHEN stock_transfers.transfer_type = 'branch_transfer'
            THEN CONCAT(
              'From ',
              COALESCE(source_territories.name, '-'),
              ' to ',
              COALESCE(destination_territories.name, '-')
            )

          WHEN stock_transfers.transfer_type = 'store_transfer'
            THEN CONCAT(
              'From ',
              COALESCE(source_stores.name, '-'),
              ' to ',
              COALESCE(destination_stores.name, '-')
            )

          WHEN stock_transfers.transfer_type = 'warehouse_transfer'
            THEN 'From Warehouse to Warehouse'

          WHEN stock_transfers.transfer_type = 'distributor_transfer'
            THEN 'From Distributor'

          ELSE '-'
        END AS transfer_description,

        SUM(
          CASE
            WHEN stock_transfers.destination_id = #{territory_id}
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            WHEN stock_transfers.transfer_type = 'distributor_transfer'
              AND stock_transfers.territory_id = #{territory_id}
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            WHEN stock_transfers.transfer_type = 'warehouse_transfer'
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            ELSE 0
          END
        ) AS inward_quantity,

        SUM(
          CASE
            WHEN stock_transfers.source_id = #{territory_id}
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            WHEN stock_transfers.transfer_type = 'warehouse_transfer'
              THEN COALESCE(stock_transfer_items.transfer_quantity, 0)

            ELSE 0
          END
        ) AS outward_quantity,

        SUM(
          COALESCE(stock_transfer_items.transfer_quantity, 0)
        ) AS total_quantity
        "
      )
      .order("nile_products.product_number ASC")

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Transfer Summary") do |sheet|
      sheet.add_row [
        "Product",
        "Transfer Type",
        "Transfer Description",
        "InWard",
        "OutWard",
        "Total"
      ]

      @transfer_items.each do |item|
        sheet.add_row [
          item.product_name,
          item.transfer_type&.humanize,
          item.transfer_description,
          item.inward_quantity.to_i,
          item.outward_quantity.to_i,
          item.total_quantity.to_i
        ]
      end
    end

    send_data(
      package.to_stream.read,
      filename: "transfer_summary_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end
  # GET /stock_transfers/1 or /stock_transfers/1.json
  def show
  end

  # GET /stock_transfers/new
  def new
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @stock_transfer = StockTransfer.new
    @warehouses = current_territory.warehouses
    @territories = Territory.all
    @products = NileProduct.all
    @stock_transfer.stock_transfer_items.build
  end

  # GET /stock_transfers/1/edit
  def edit
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @warehouses = current_territory.warehouses
    @territories = Territory.all
    @products = NileProduct.all
  end

  # POST /stock_transfers or /stock_transfers.json
  def create
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @stock_transfer = StockTransfer.new(stock_transfer_params)
    @warehouses = current_territory.warehouses
    @territories = Territory.all
    @products = NileProduct.all
    
    respond_to do |format|
      if @stock_transfer.save
        format.html { redirect_to inventory_items_path, notice: "Stock transfer was successfully created." }
        format.json { render :show, status: :created, location: @stock_transfer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_transfers/1 or /stock_transfers/1.json
  def update
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @warehouses = current_territory.warehouses
    @territories = Territory.all
    @products = NileProduct.all
    respond_to do |format|
      if @stock_transfer.update(stock_transfer_params)
        format.html { redirect_to inventory_items_path, notice: "Stock transfer was successfully updated." }
        format.json { render :show, status: :ok, location: @stock_transfer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_transfers/1 or /stock_transfers/1.json
  def destroy
    @stock_transfer.destroy!

    respond_to do |format|
      format.html { redirect_to stock_transfers_path, status: :see_other, notice: "Stock transfer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_transfer
      @stock_transfer = StockTransfer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_transfer_params
      params.require(:stock_transfer).permit(:transfer_type, :source_type, :source_id, :destination_type, :destination_id, :transfer_date, :description, :status,:territory_id,
      stock_transfer_items_attributes: [:id, :nile_product_id, :stock_transfer_id, :transfer_quantity, :_destroy ])
    end
end
