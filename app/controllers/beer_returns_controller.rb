class BeerReturnsController < ApplicationController
  before_action :set_beer_return, only: %i[ show edit update destroy ]

  # GET /beer_returns or /beer_returns.json
  def index
    @active_link = "purchases"
    @active_sub_link = "returns"
    @beer_returns = BeerReturn.search(params, current_territory.id).order(created_at: :desc).page(params[:page]).per(20)
  end

  def export
    @beer_returns = BeerReturn
                      .search(params, current_territory.id)
                      .order(created_at: :desc)
                      .includes(
                        loading_order: :store,
                        beer_return_items: :nile_product
                      )

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Beer Returns") do |sheet|
      sheet.add_row [
        "Return Date",
        "Order Number",
        "Sales Person",
        "Driver",
        "Vehicle",
        "Store",
        "Product",
        "Qty Loaded",
        "Qty Returned",
        "Qty Stashed",
        "Missing Bottles"
      ]

      @beer_returns.each do |beer_return|
        loading_order = beer_return.loading_order
        store = loading_order&.store

        beer_return.beer_return_items.each do |item|
          sheet.add_row [
            beer_return.return_date&.strftime("%d-%b-%Y"),
            loading_order&.order_number,
            loading_order&.sales_person,
            loading_order&.driver_name,
            loading_order&.vehicle_numperplate,
            store&.name,
            item.nile_product&.name,
            item.quantity_loaded,
            item.quantity_returned,
            item.holding_sale_quantity,
            item.missing_bottles
          ]
        end
      end
    end

    send_data(
      package.to_stream.read,
      filename: "beer_returns_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  # GET /beer_returns/holding_sale or /beer_returns/holding_sale.json
  def holding_sale
    @active_link = "purchases"
    @active_sub_link = "holding_sale"
    @beer_returns = BeerReturn.search(params, current_territory.id).order(created_at: :desc).page(params[:page]).per(20)
  end
  
  # GET /beer_returns/summary
  def return_summary
    @active_link = "purchases"
    @active_sub_link = "returns"

    @stores = current_territory.stores.order(:name)

    @products = NileProduct
                  .order(:product_number)
                  .page(params[:page])
                  .per(20)

    # Optional search
    if params[:query].present?
      @products = @products.where(
        "nile_products.name LIKE ?",
        "%#{params[:query]}%"
      )
    end

    # Base query
    query = BeerReturnItem
      .joins(beer_return: :loading_order)
      .where(
        beer_returns: {
          territory_id: current_territory.id
        }
      )

    # Date filters
    if params[:start_date].present?
      query = query.where(
        "DATE(beer_returns.return_date) >= ?",
        params[:start_date]
      )
    end

    if params[:end_date].present?
      query = query.where(
        "DATE(beer_returns.return_date) <= ?",
        params[:end_date]
      )
    end

    # Summary data
    raw_data = query
      .group(
        :nile_product_id,
        "loading_orders.store_id"
      )
      .sum(:quantity_returned)

    # Convert to nested hash
    @report_data = {}

    raw_data.each do |(product_id, store_id), quantity|
      @report_data[product_id] ||= {}
      @report_data[product_id][store_id] = quantity
    end
  end

  def export_return_summary
    @stores = current_territory.stores.order(:name)

    # Same products query as page
    @products = NileProduct.order(:product_number)

    if params[:query].present?
      @products = @products.where(
        "nile_products.name LIKE ?",
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"
      )
    end

    # Same return query as page
    query = BeerReturnItem
              .joins(beer_return: :loading_order)
              .where(
                beer_returns: {
                  territory_id: current_territory.id
                }
              )

    # Start date
    if params[:start_date].present?
      query = query.where(
        "DATE(beer_returns.return_date) >= ?",
        params[:start_date]
      )
    end

    # End date
    if params[:end_date].present?
      query = query.where(
        "DATE(beer_returns.return_date) <= ?",
        params[:end_date]
      )
    end

    # Same grouped summary
    raw_data = query
                .group(
                  :nile_product_id,
                  "loading_orders.store_id"
                )
                .sum(:quantity_returned)

    @report_data = {}

    raw_data.each do |(product_id, store_id), quantity|
      @report_data[product_id] ||= {}
      @report_data[product_id][store_id] = quantity
    end

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Return Summary") do |sheet|
      # Header
      headers = ["Product"]
      headers += @stores.map(&:name)
      headers << "Total Returned"

      sheet.add_row headers

      grand_total = 0

      # Product rows
      @products.each do |product|
        row = [product.name]
        row_total = 0

        @stores.each do |store|
          quantity =
            @report_data
              .dig(product.id, store.id)
              .to_i

          row_total += quantity
          row << quantity
        end

        grand_total += row_total
        row << row_total
        sheet.add_row row
      end

      # Footer totals
      footer = ["Totals"]

      @stores.each do |store|
        store_total = @products.sum do |product|
          @report_data
            .dig(product.id, store.id)
            .to_i
        end

        footer << store_total
      end

      footer << grand_total
      sheet.add_row footer
    end

    send_data(
      package.to_stream.read,
      filename: "return_summary_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  # GET /beer_returns/holding_sale_summary
  def holding_sale_summary
    @active_link = "purchases"
    @active_sub_link = "holding_sale"

    @stores = current_territory.stores.order(:name)

    @products = NileProduct
                  .order(:product_number)
                  .page(params[:page])
                  .per(20)

    # Optional search
    if params[:query].present?
      @products = @products.where(
        "nile_products.name LIKE ?",
        "%#{params[:query]}%"
      )
    end

    # Summary data
    raw_data = BeerReturnItem
      .joins(beer_return: :loading_order)
      .where(
        beer_returns: {
          territory_id: current_territory.id
        }
      )
      .group(
        :nile_product_id,
        "loading_orders.store_id"
      )
      .sum(:holding_sale_quantity)

    # Convert to nested hash
    @report_data = {}

    raw_data.each do |(product_id, store_id), quantity|
      @report_data[product_id] ||= {}
      @report_data[product_id][store_id] = quantity
    end
  end

  # GET /beer_returns/1 or /beer_returns/1.json
  def show
  end

  # GET /beer_returns/new
  def new
    @active_link = "purchases"
    @active_sub_link = "returns"
    @order = LoadingOrder.find(params[:id])

    @beer_return = BeerReturn.new

    @order.loading_order_items.each do |order_item|
      @beer_return.beer_return_items.build(
        nile_product_id: order_item.nile_product_id,
        quantity_loaded: order_item.quantity_loaded
      )
    end

    @order_items = NileProduct.where(
      id: @order.loading_order_items.pluck(:nile_product_id)
    )
  end
  # GET /beer_returns/1/edit
  def edit
    @active_link = "purchases"
    @active_sub_link = "returns"
    @order = LoadingOrder.find(@beer_return.loading_order_id)

    @order_items = NileProduct.where(
      id: @order.loading_order_items.pluck(:nile_product_id)
    )
  end

  # POST /beer_returns or /beer_returns.json
  def create
    @active_link = "purchases"
    @active_sub_link = "returns"
    order_id = beer_return_params[:loading_order_id]

    @order = LoadingOrder.find(order_id)

    @beer_return = BeerReturn.new(beer_return_params)

    @order_items = NileProduct.where(
      id: @order.loading_order_items.pluck(:nile_product_id)
    )

    respond_to do |format|
      if @beer_return.save
        format.html {
          redirect_to beer_returns_path,
          notice: "Beer return was successfully created."
        }
        format.json { render :show, status: :created, location: @beer_return }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer_return.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_returns/1 or /beer_returns/1.json
  def update
    @active_link = "purchases"
    @active_sub_link = "returns"
    @order = LoadingOrder.find(@beer_return.loading_order_id)

    @order_items = NileProduct.where(
      id: @order.loading_order_items.pluck(:nile_product_id)
    )
    respond_to do |format|
      if @beer_return.update(beer_return_params)
        format.html { redirect_to beer_returns_path, notice: "Beer return was successfully updated." }
        format.json { render :show, status: :ok, location: @beer_return }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer_return.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_returns/1 or /beer_returns/1.json
  def destroy
    @beer_return.destroy!

    respond_to do |format|
      format.html { redirect_to beer_returns_path, status: :see_other, notice: "Beer return was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer_return
      @beer_return = BeerReturn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def beer_return_params
      params.require(:beer_return).permit(:loading_order_id, :return_date, :territory_id,
      beer_return_items_attributes: [:id, :nile_product_id, :quantity_loaded, :quantity_returned, :holding_sale_quantity,:missing_bottles, :_destroy])
    end
end
