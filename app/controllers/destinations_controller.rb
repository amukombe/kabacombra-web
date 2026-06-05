class DestinationsController < ApplicationController
  before_action :set_destination, only: %i[ show edit update destroy ]

  # GET /destinations or /destinations.json
  def index
    @destinations = Destination.search(params).page(params[:page]).per(20)
  end

  # GET /destinations/1 or /destinations/1.json
  def show
  end

  # GET /destinations/new
  def new
    @nile_products = NileProduct.all
    @destination = Destination.new
  end

  # GET /destinations/1/edit
  def edit
    @nile_products = NileProduct.all
  end

  # POST /destinations or /destinations.json
  def create
    @nile_products = NileProduct.all
    @destination = Destination.new(destination_params)

    respond_to do |format|
      if @destination.save
        format.html { redirect_to destinations_path, notice: "Destination was successfully created." }
        format.json { render :show, status: :created, location: @destination }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @destination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /destinations/1 or /destinations/1.json
  def update
    @nile_products = NileProduct.all
    respond_to do |format|
      if @destination.update(destination_params)
        format.html { redirect_to destinations_path, notice: "Destination was successfully updated." }
        format.json { render :show, status: :ok, location: @destination }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @destination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /destinations/1 or /destinations/1.json
  def destroy
    @destination.destroy!

    respond_to do |format|
      format.html { redirect_to destinations_path, status: :see_other, notice: "Destination was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_destination
      @destination = Destination.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def destination_params
      params.require(:destination).permit(:nile_product_id, :selling_price, :name)
    end
end
