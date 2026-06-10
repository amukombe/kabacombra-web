class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @active_link = "orders"
    @orders = Order.search(params, current_territory.id).page(params[:page]).per(20)
  end

  def export
    @orders = Order
                .search(params, current_territory.id)
                .includes(
                  :status,
                  order_items: :nile_product
                )

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Orders") do |sheet|
      sheet.add_row [
        "Order Date",
        "Order Number",
        "Route",
        "Status",
        "Product",
        "Qty Ordered",
        "Rate",
        "Total"
      ]

      @orders.each do |order|
        order.order_items.each do |item|
          sheet.add_row [
            order.order_date&.strftime("%d-%b-%Y"),
            order.order_number,
            order.description,
            order.status&.name,
            item.nile_product&.name,
            item.quantity,
            item.unit_price,
            item.total
          ]
        end

        # Total row per order
        sheet.add_row [
          nil,
          nil,
          nil,
          nil,
          "TOTAL",
          nil,
          nil,
          order.total_price
        ]
      end
    end

    send_data(
      package.to_stream.read,
      filename: "orders_#{Date.today}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  def canceled
    @active_link = "canceled"
    @orders = Order.search_canceled(params, current_territory.id).page(params[:page]).per(20)
  end

  def cancel
    @order = Order.find(params[:id])

    if @order.update(
        status_id: 5
      )

      redirect_to orders_path,
                  notice: "Order canceled successfully."
    else
      render :index, status: :unprocessable_entity, alert: "Failed to cancel order."
    end
  end
  def reverse
    @order = Order.find(params[:id])

    if @order.update(
        status_id: 2
      )

      redirect_to canceled_orders_path,
                  notice: "Order reversed successfully."
    else
      render :canceled, status: :unprocessable_entity, alert: "Failed to reverse order."
    end
  end
  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new(order_date: Date.today, departure_date: Date.today)
    @order.order_items.build
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
  end

  # GET /orders/1/edit
  def edit
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @routes = Route.all
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    @products = NileProduct.all
    @units = UnitOfMeasurement.all
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_path, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def approve_driver
    @order = Order.find(params[:id])
    @drivers = Driver.all
    @order_driver = @order.order_drivers.build
  end

  def update_driver_approval
    @order = Order.find(params[:id])
    @order_driver = @order.order_drivers.build(order_driver_params)

    if @order_driver.save
      redirect_to request_path, notice: "Driver assigned successfully."
    else
      @drivers = Driver.all
      flash.now[:alert] = "Failed to assign driver."
      render :assign_department, status: :unprocessable_entity
    end
  end

  def assign_driver
    @order = Order.find(params[:id])
    @drivers = Driver.all
    @order_driver = @order.order_drivers.build
  end

  def update_driver
    @order = Order.find(params[:id])
    @order_driver = @order.order_drivers.build(order_driver_params)

    if @order_driver.save
      @order.update(status_id: 2)
      @driver =Driver.find(@order_driver.driver.id)
      @driver.update(is_available: false)
      redirect_to orders_path, notice: "Driver assigned successfully."
    else
      @drivers = Driver.all
      flash.now[:alert] = "Failed to assign driver."
      render :assign_department, status: :unprocessable_entity
    end
  end

  def remove_driver
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

  def dispatch_pdf
    @order = Order.find(params[:id])  # Make sure you find the order
    @dispatch = @order.beer_dispatch
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "orders/dispatch_pdf", formats: [:html], disposition: :inline, layout: 'pdf'   # Excluding ".pdf" extension.
      end
    end
  end

  #vendor statement
  def vendor_statement
    @date = Date.today # params[:date].present? ? Date.parse(params[:date]) : Date.today
    @statements = InventoryTransaction.daily_statement(@date)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:order_number, :order_date, :user_id, :status_id, :total_price,:departure_date,:description,:territory_id,
      order_items_attributes: [:id, :nile_product_id, :quantity, :unit_price, :total,:unit_of_measurement_id, :_destroy])
    end

    def order_driver_params
      params.require(:order_driver).permit(:order_id, :driver_id)
    end
end
