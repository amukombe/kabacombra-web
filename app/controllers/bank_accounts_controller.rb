class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[ show edit update destroy ]
  before_action :set_active_link
  # GET /bank_accounts or /bank_accounts.json
  def index
    @active_link='bank accounts'
    @bank_accounts = BankAccount.search(params, current_territory.id).page(params[:page]).per(20)
  end

  # GET /bank_accounts/1 or /bank_accounts/1.json
  def show
  end

  # GET /bank_accounts/new
  def new
    @bank_account = BankAccount.new
    @banks = Bank.all
    @territories = Territory.all
  end

  # GET /bank_accounts/1/edit
  def edit
    @territories = Territory.all
  end

  # POST /bank_accounts or /bank_accounts.json
  def create
    @bank_account = BankAccount.new(bank_account_params)
    @banks = Bank.all
    @territories = Territory.all
    respond_to do |format|
      if @bank_account.save
        format.html { redirect_to bank_accounts_path, notice: "Bank account was successfully created." }
        format.json { render :show, status: :created, location: @bank_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_accounts/1 or /bank_accounts/1.json
  def update
    @banks = Bank.all
    @territories = Territory.all
    respond_to do |format|
      if @bank_account.update(bank_account_params)
        format.html { redirect_to bank_accounts_path, notice: "Bank account was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_accounts/1 or /bank_accounts/1.json
  def destroy
    @bank_account.destroy!

    respond_to do |format|
      format.html { redirect_to bank_accounts_path, status: :see_other, notice: "Bank account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_account
      @bank_account = BankAccount.find(params[:id])
    end

    def set_active_link
      @active_link = "bank accounts"
    end

    # Only allow a list of trusted parameters through.
    def bank_account_params
      params.require(:bank_account).permit(:bank_id, :territory_id, :user_id, :account_name, :account_number, :branch_name, :branch_code, :swiftcode)
    end
end
