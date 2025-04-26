class InventoryTransactionsController < ApplicationController
  before_action :set_inventory_transaction, only: %i[ show edit update destroy ]

  # GET /inventory_transactions or /inventory_transactions.json
  def index
    @inventory_transactions = InventoryTransaction.all
  end

  # GET /inventory_transactions/1 or /inventory_transactions/1.json
  def show
  end

  # GET /inventory_transactions/new
  def new
    @inventory_transaction = InventoryTransaction.new
  end

  # GET /inventory_transactions/1/edit
  def edit
  end

  # POST /inventory_transactions or /inventory_transactions.json
  def create
    @inventory_transaction = InventoryTransaction.new(inventory_transaction_params)

    respond_to do |format|
      if @inventory_transaction.save
        format.html { redirect_to @inventory_transaction, notice: "Inventory transaction was successfully created." }
        format.json { render :show, status: :created, location: @inventory_transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_transactions/1 or /inventory_transactions/1.json
  def update
    respond_to do |format|
      if @inventory_transaction.update(inventory_transaction_params)
        format.html { redirect_to @inventory_transaction, notice: "Inventory transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory_transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_transactions/1 or /inventory_transactions/1.json
  def destroy
    @inventory_transaction.destroy!

    respond_to do |format|
      format.html { redirect_to inventory_transactions_path, status: :see_other, notice: "Inventory transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_transaction
      @inventory_transaction = InventoryTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inventory_transaction_params
      params.require(:inventory_transaction).permit(:inventory_item_id, :transaction_date, :transaction_quantity, :transaction_type, :direction, :note)
    end
end
