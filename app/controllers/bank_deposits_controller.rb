class BankDepositsController < ApplicationController
  before_action :set_bank_deposit, only: %i[ show edit update destroy ]

  # GET /bank_deposits or /bank_deposits.json
  def index
    @active_link='deposits'
    @bank_deposits = BankDeposit.search(params, current_territory.id).page(params[:page]).per(20)
  end

  # GET /bank_deposits/1 or /bank_deposits/1.json
  def show
  end

  # GET /bank_deposits/new
  def new
    @bank_deposit = BankDeposit.new
    @bank_accounts = BankAccount.all
  end

  # GET /bank_deposits/1/edit
  def edit
    @bank_accounts = BankAccount.all
  end

  # POST /bank_deposits or /bank_deposits.json
  def create
    @bank_deposit = BankDeposit.new(bank_deposit_params)

    respond_to do |format|
      if @bank_deposit.save
        format.html { redirect_to bank_deposits_path, notice: "Bank deposit was successfully created." }
        format.json { render :show, status: :created, location: @bank_deposit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_deposits/1 or /bank_deposits/1.json
  def update
    @bank_accounts = BankAccount.all
    respond_to do |format|
      if @bank_deposit.update(bank_deposit_params)
        format.html { redirect_to bank_deposits_path, notice: "Bank deposit was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_deposit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_deposits/1 or /bank_deposits/1.json
  def destroy
    @bank_deposit.destroy!

    respond_to do |format|
      format.html { redirect_to bank_deposits_path, status: :see_other, notice: "Bank deposit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_deposit
      @bank_deposit = BankDeposit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bank_deposit_params
      params.require(:bank_deposit).permit(:bank_account_id, :user_id, :territory_id, :deposit_date, :amount, :deposit_location, :source_of_income, :deposited_by, :transaction_reference, :additional_info)
    end
end
