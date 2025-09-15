class BankTransfersController < ApplicationController
  before_action :set_bank_transfer, only: %i[ show edit update destroy ]
  before_action :set_active_link
  # GET /bank_transfers or /bank_transfers.json
  def index
    @territory = Territory.find(current_territory.id)
    @bank_transfers = @territory.bank_transfers.order(transfer_date: :desc).page(params[:page]).per(10)
  end

  # GET /bank_transfers/1 or /bank_transfers/1.json
  def show
  end

  # GET /bank_transfers/new
  def new
    @bank_transfer = BankTransfer.new(transfer_date: DateTime.now)
    @current_territory = Territory.find(current_territory.id)
    @bank_accounts = @current_territory.bank_accounts.order(:account_number)
  end

  # GET /bank_transfers/1/edit
  def edit
    @current_territory = Territory.find(current_territory.id)
    @bank_accounts = @current_territory.bank_accounts.order(:account_number)
  end

  # POST /bank_transfers or /bank_transfers.json
  def create
    @bank_transfer = BankTransfer.new(bank_transfer_params)
    @current_territory = Territory.find(current_territory.id)
    @bank_accounts = @current_territory.bank_accounts.order(:account_number)
    respond_to do |format|
      if @bank_transfer.save
        format.html { redirect_to bank_transfers_path, notice: "Bank transfer was successfully created." }
        format.json { render :show, status: :created, location: @bank_transfer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_transfers/1 or /bank_transfers/1.json
  def update
    @current_territory = Territory.find(current_territory.id)
    @bank_accounts = @current_territory.bank_accounts.order(:account_number)
    respond_to do |format|
      if @bank_transfer.update(bank_transfer_params)
        format.html { redirect_to bank_transfers_path, notice: "Bank transfer was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_transfer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_transfers/1 or /bank_transfers/1.json
  def destroy
    @bank_transfer.destroy!

    respond_to do |format|
      format.html { redirect_to bank_transfers_path, status: :see_other, notice: "Bank transfer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_transfer
      @bank_transfer = BankTransfer.find(params[:id])
    end

    def set_active_link
      @active_link = 'transfers'
    end

    # Only allow a list of trusted parameters through.
    def bank_transfer_params
      params.require(:bank_transfer).permit(:user_id, :territory_id, :from_account_id, :to_account_id, :transfer_date, :amount, :reason, :transfer_ref)
    end
end
