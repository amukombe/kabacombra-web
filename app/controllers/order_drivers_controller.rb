class OrderDriversController < ApplicationController
  before_action :set_order_driver, only: %i[ show edit update destroy ]

  # GET /order_drivers or /order_drivers.json
  def index
    @order_drivers = OrderDriver.all
  end

  # GET /order_drivers/1 or /order_drivers/1.json
  def show
  end

  # GET /order_drivers/new
  def new
    @order_driver = OrderDriver.new
  end

  # GET /order_drivers/1/edit
  def edit
  end

  # POST /order_drivers or /order_drivers.json
  def create
    @order_driver = OrderDriver.new(order_driver_params)

    respond_to do |format|
      if @order_driver.save
        format.html { redirect_to @order_driver, notice: "Order driver was successfully created." }
        format.json { render :show, status: :created, location: @order_driver }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_drivers/1 or /order_drivers/1.json
  def update
    respond_to do |format|
      if @order_driver.update(order_driver_params)
        format.html { redirect_to @order_driver, notice: "Order driver was successfully updated." }
        format.json { render :show, status: :ok, location: @order_driver }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_drivers/1 or /order_drivers/1.json
  def destroy
    @order_driver.destroy!

    respond_to do |format|
      format.html { redirect_to order_drivers_path, status: :see_other, notice: "Order driver was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_driver
      @order_driver = OrderDriver.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_driver_params
      params.require(:order_driver).permit(:order_id, :driver_id)
    end
end
