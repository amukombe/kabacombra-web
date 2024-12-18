class TrucksController < ApplicationController
  before_action :set_truck, only: %i[ show edit update destroy ]

  # GET /trucks or /trucks.json
  def index
    @trucks = Truck.search(params).page(params[:page]).per(20)
  end

  # GET /trucks/1 or /trucks/1.json
  def show
  end

  # GET /trucks/new
  def new
    @truck = Truck.new
    @car_makes = CarMake.all
    @truck_types = TruckType.all
  end

  # GET /trucks/1/edit
  def edit
    @car_makes = CarMake.all
    @truck_types = TruckType.all
  end

  # POST /trucks or /trucks.json
  def create
    @truck = Truck.new(truck_params)
    @car_makes = CarMake.all
    @truck_types = TruckType.all
    respond_to do |format|
      if @truck.save
        format.html { redirect_to trucks_path, notice: "Truck was successfully created." }
        format.json { render :show, status: :created, location: @truck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trucks/1 or /trucks/1.json
  def update
    @car_makes = CarMake.all
    @truck_types = TruckType.all
    respond_to do |format|
      if @truck.update(truck_params)
        format.html { redirect_to trucks_path, notice: "Truck was successfully updated." }
        format.json { render :show, status: :ok, location: @truck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trucks/1 or /trucks/1.json
  def destroy
    @truck.destroy!

    respond_to do |format|
      format.html { redirect_to trucks_path, status: :see_other, notice: "Truck was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_driver
    @truck = Truck.find(params[:id])
    @drivers = Driver.all
    @truck_driver = @truck.truck_drivers.build
  end

  def update_driver
    @truck = Truck.find(params[:id])
    @truck_driver = @truck.truck_drivers.build(truck_driver_params)

    if @truck_driver.save
      redirect_to trucks_path, notice: "Driver assigned successfully."
    else
      @drivers = Driver.all
      flash.now[:alert] = "Failed to assign driver."
      render :assign_driver, status: :unprocessable_entity
    end
  end

  def remove_driver
    @truck_driver = TruckDriver.find(params[:id])
  
    if @truck_driver.destroy
      respond_to do |format|
        format.html { redirect_to trucks_path, notice: "Driver successfully removed." }
        format.js   # If you want to handle it via JavaScript
      end
    else
      respond_to do |format|
        format.html { redirect_to trucks_path, alert: "Failed to remove driver." }
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_truck
      @truck = Truck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def truck_params
      params.require(:truck).permit(:plate_number, :model, :chasis, :status, :car_make_id, :truck_type_id)
    end
    def truck_driver_params
      params.require(:truck_driver).permit(:driver_id, :user_id, :date_assigned)
    end
end
