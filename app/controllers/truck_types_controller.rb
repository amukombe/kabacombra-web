class TruckTypesController < ApplicationController
  before_action :set_truck_type, only: %i[ show edit update destroy ]

  # GET /truck_types or /truck_types.json
  def index
    @truck_types = TruckType.search(params).page(params[:page]).per(20)
  end

  # GET /truck_types/1 or /truck_types/1.json
  def show
  end

  # GET /truck_types/new
  def new
    @truck_type = TruckType.new
  end

  # GET /truck_types/1/edit
  def edit
  end

  # POST /truck_types or /truck_types.json
  def create
    @truck_type = TruckType.new(truck_type_params)

    respond_to do |format|
      if @truck_type.save
        format.html { redirect_to truck_types_path, notice: "Truck type was successfully created." }
        format.json { render :show, status: :created, location: @truck_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @truck_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /truck_types/1 or /truck_types/1.json
  def update
    respond_to do |format|
      if @truck_type.update(truck_type_params)
        format.html { redirect_to truck_types_path, notice: "Truck type was successfully updated." }
        format.json { render :show, status: :ok, location: @truck_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @truck_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /truck_types/1 or /truck_types/1.json
  def destroy
    @truck_type.destroy!

    respond_to do |format|
      format.html { redirect_to truck_types_path, status: :see_other, notice: "Truck type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_truck_type
      @truck_type = TruckType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def truck_type_params
      params.require(:truck_type).permit(:name, :description)
    end
end
