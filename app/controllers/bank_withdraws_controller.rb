class BankWithdrawsController < ApplicationController
  before_action :set_bank_withdraw, only: %i[ show edit update destroy ]
  before_action :set_active_link
  # GET /bank_withdraws or /bank_withdraws.json
  def index
    @bank_withdraws = BankWithdraw.search(params, current_territory.id).page(params[:page]).per(20)
  end

  # GET /bank_withdraws/1 or /bank_withdraws/1.json
  def show
  end

  # GET /bank_withdraws/new
  def new
    @bank_withdraw = BankWithdraw.new
    @bank_accounts = BankAccount.all
  end

  # GET /bank_withdraws/1/edit
  def edit
    @bank_accounts = BankAccount.all
  end

  # POST /bank_withdraws or /bank_withdraws.json
  def create
    @bank_withdraw = BankWithdraw.new(bank_withdraw_params)
    @bank_accounts = BankAccount.all
    respond_to do |format|
      if @bank_withdraw.save
        format.html { redirect_to bank_withdraws_path, notice: "Bank withdraw was successfully created." }
        format.json { render :show, status: :created, location: @bank_withdraw }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_withdraw.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_withdraws/1 or /bank_withdraws/1.json
  def update
    @bank_accounts = BankAccount.all
    respond_to do |format|
      if @bank_withdraw.update(bank_withdraw_params)
        format.html { redirect_to bank_withdraws_path, notice: "Bank withdraw was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_withdraw }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_withdraw.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_withdraws/1 or /bank_withdraws/1.json
  def destroy
    @bank_withdraw.destroy!

    respond_to do |format|
      format.html { redirect_to bank_withdraws_path, status: :see_other, notice: "Bank withdraw was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_withdraw
      @bank_withdraw = BankWithdraw.find(params[:id])
    end

    def set_active_link
      @active_link = "withdraws"
    end

    # Only allow a list of trusted parameters through.
    def bank_withdraw_params
      params.require(:bank_withdraw).permit(:bank_account_id, :user_id, :territory_id, :withdraw_date, :amount, :withdraw_location, :reason, :withdrawn_by, :transaction_reference, :additional_info)
    end
end
