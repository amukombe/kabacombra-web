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
      .group(
        "nile_products.id,
        nile_products.name"
      )
      .select(
        "
        nile_products.id,
        nile_products.name AS product_name,

        -- Inward
        COALESCE(
          SUM(
            CASE

              -- Received by this territory
              WHEN stock_transfers.destination_id = #{territory_id}
                THEN stock_transfer_items.quantity_received

              -- Distributor transfer
              WHEN stock_transfers.transfer_type = 'distributor_transfer'
                AND stock_transfers.territory_id = #{territory_id}
                THEN stock_transfer_items.quantity_received

              -- Warehouse transfer
              WHEN stock_transfers.transfer_type = 'warehouse_transfer'
                THEN stock_transfer_items.quantity_received

              ELSE 0
            END
          ),
        0) AS inward_quantity,

        -- Outward
        COALESCE(
          SUM(
            CASE

              -- Sent by this territory
              WHEN stock_transfers.source_id = #{territory_id}
                THEN stock_transfer_items.quantity_received

              -- Warehouse transfer
              WHEN stock_transfers.transfer_type = 'warehouse_transfer'
                THEN stock_transfer_items.quantity_received

              ELSE 0
            END
          ),
        0) AS outward_quantity,

        -- Total
        COALESCE(
          SUM(stock_transfer_items.quantity_received),
        0) AS total_quantity
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
      .group(
        "nile_products.id,
        nile_products.name"
      )
      .select(
        "
        nile_products.id,
        nile_products.name AS product_name,

        -- Inward
        COALESCE(
          SUM(
            CASE

              -- Received by this territory
              WHEN stock_transfers.destination_id = #{territory_id}
                THEN stock_transfer_items.quantity_received

              -- Distributor transfer
              WHEN stock_transfers.transfer_type = 'distributor_transfer'
                AND stock_transfers.territory_id = #{territory_id}
                THEN stock_transfer_items.quantity_received

              -- Warehouse transfer
              WHEN stock_transfers.transfer_type = 'warehouse_transfer'
                THEN stock_transfer_items.quantity_received

              ELSE 0
            END
          ),
        0) AS inward_quantity,

        -- Outward
        COALESCE(
          SUM(
            CASE

              -- Sent by this territory
              WHEN stock_transfers.source_id = #{territory_id}
                THEN stock_transfer_items.quantity_received

              -- Warehouse transfer
              WHEN stock_transfers.transfer_type = 'warehouse_transfer'
                THEN stock_transfer_items.quantity_received

              ELSE 0
            END
          ),
        0) AS outward_quantity,

        -- Total
        COALESCE(
          SUM(stock_transfer_items.quantity_received),
        0) AS total_quantity
        "
      )
      .order("nile_products.product_number ASC")

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Transfer Summary") do |sheet|

      # Header
      sheet.add_row [
        "Product",
        "InWard",
        "OutWard",
        "Total"
      ]

      # Rows
      @transfer_items.each do |item|
        sheet.add_row [
          item.product_name,
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
    @stock_transfer.user = current_user
    respond_to do |format|
      if @stock_transfer.save
        format.html { redirect_to stock_transfers_path, notice: "Stock transfer was successfully created." }
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
      @stock_transfer.user = current_user
      if @stock_transfer.update(stock_transfer_params)
        format.html { redirect_to stock_transfers_path, notice: "Stock transfer was successfully updated." }
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

  def receive
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @stock_transfer = StockTransfer
                        .includes(stock_transfer_items: :nile_product)
                        .find(params[:id])
  end

  def submit_receive
    @stock_transfer = StockTransfer.find(params[:id])

    ActiveRecord::Base.transaction do

      if @stock_transfer.update(receive_params)

        @stock_transfer.update!(
          status: "received",
          received_by: current_user.id,
          received_at: Time.current
        )

        # CREATE TRANSACTIONS HERE
        @stock_transfer.create_inventory_transactions

        redirect_to stock_transfers_path,
                    notice: "Transfer received successfully."

      else
        render :receive
      end

    end
  end

  def reject
    @active_link = "purchases"
    @active_sub_link = "stock_transfers"
    @stock_transfer = StockTransfer.find(params[:id])
  end

  def submit_reject
    @stock_transfer = StockTransfer.find(params[:id])

    if @stock_transfer.update(
        status: "rejected",
        rejection_reason: params[:stock_transfer][:rejection_reason]
      )

      redirect_to stock_transfers_path,
                  notice: "Transfer rejected successfully."
    else
      render :reject
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_transfer
      @stock_transfer = StockTransfer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_transfer_params
      params.require(:stock_transfer).permit(:transfer_type, :source_type, :source_id, :destination_type, :destination_id, :transfer_date, :description, :status,:territory_id, :numberplate, :driver_details,
      stock_transfer_items_attributes: [:id, :nile_product_id, :stock_transfer_id, :transfer_quantity, :_destroy ])
    end

    def receive_params
  params.require(:stock_transfer).permit(stock_transfer_items_attributes: [:id, :quantity_received, :breakages, :complaints])
end
end
