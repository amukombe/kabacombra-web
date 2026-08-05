class BankReconciliationItemsController < ApplicationController
  before_action :set_bank_reconciliation_item, only: %i[ show edit update destroy ]

  # GET /bank_reconciliation_items or /bank_reconciliation_items.json
  def index
    @bank_reconciliation_items = BankReconciliationItem.all
  end

  # GET /bank_reconciliation_items/1 or /bank_reconciliation_items/1.json
  def show
  end

  # GET /bank_reconciliation_items/new
  def new
    @bank_reconciliation_item = BankReconciliationItem.new
  end

  # GET /bank_reconciliation_items/1/edit
  def edit
  end

  # POST /bank_reconciliation_items or /bank_reconciliation_items.json
  def create
    @bank_reconciliation_item = BankReconciliationItem.new(bank_reconciliation_item_params)

    respond_to do |format|
      if @bank_reconciliation_item.save
        format.html { redirect_to @bank_reconciliation_item, notice: "Bank reconciliation item was successfully created." }
        format.json { render :show, status: :created, location: @bank_reconciliation_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_reconciliation_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_reconciliation_items/1 or /bank_reconciliation_items/1.json
  def update
    respond_to do |format|
      if @bank_reconciliation_item.update(bank_reconciliation_item_params)
        format.html { redirect_to @bank_reconciliation_item, notice: "Bank reconciliation item was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_reconciliation_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_reconciliation_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_reconciliation_items/1 or /bank_reconciliation_items/1.json
  def destroy
    @bank_reconciliation_item.destroy!

    respond_to do |format|
      format.html { redirect_to bank_reconciliation_items_path, status: :see_other, notice: "Bank reconciliation item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_reconciliation_item
      @bank_reconciliation_item = BankReconciliationItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bank_reconciliation_item_params
      params.require(:bank_reconciliation_item).permit(:bank_reconciliation_id, :bank_transaction_id, :bank_date, :bank_reference, :description, :bank_amount, :matched, :cleared, :notes)
    end
end
