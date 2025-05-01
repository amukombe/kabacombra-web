class StockTransfersController < ApplicationController
  before_action :set_stock_transfer, only: %i[ show edit update destroy ]

  # GET /stock_transfers or /stock_transfers.json
  def index
    @stock_transfers = StockTransfer.all
  end

  # GET /stock_transfers/1 or /stock_transfers/1.json
  def show
  end

  # GET /stock_transfers/new
  def new
    @stock_transfer = StockTransfer.new
    @warehouses = current_territory.warehouses
    @territories = Territory.all
    @products = NileProduct.all
    @stock_transfer.stock_transfer_items.build
  end

  # GET /stock_transfers/1/edit
  def edit
  end

  # POST /stock_transfers or /stock_transfers.json
  def create
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
