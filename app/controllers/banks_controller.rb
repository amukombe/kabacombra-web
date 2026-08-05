class BanksController < ApplicationController
  before_action :set_bank, only: %i[ show edit update destroy statement]
  before_action :set_active_link
  # GET /banks or /banks.json
  def index
    @active_link='banks'
    @banks = Bank.search(params).page(params[:page]).per(20)
  end

  def statement
    @active_link = "banking"
    load_statement
    load_statement_summary
  end

  # GET /banks/1 or /banks/1.json
  def show
  end

  # GET /banks/new
  def new
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks or /banks.json
  def create
    @bank = Bank.new(bank_params)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to banks_path, notice: "Bank was successfully created." }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banks/1 or /banks/1.json
  def update
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to banks_path, notice: "Bank was successfully updated." }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1 or /banks/1.json
  def destroy
    @bank.destroy!

    respond_to do |format|
      format.html { redirect_to banks_path, status: :see_other, notice: "Bank was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def load_statement
      params[:start_date] ||= Date.current.beginning_of_month.to_s
      params[:end_date] ||= Date.current.to_s

      @transactions =
        @bank_account
          .bank_transactions
          .includes(:financial_transaction)
          .where(
            cleared_date:
              params[:start_date]..
              params[:end_date]
          )
          .order(
            :cleared_date,
            :created_at
          )

    end
    def load_statement_summary

      @opening_balance = 0

      @total_deposits =
        @transactions
          .where(method: "deposit")
          .sum(:amount)

      @total_withdrawals =
        @transactions
          .where
          .not(method: "deposit")
          .sum(:amount)

      @closing_balance =
          @opening_balance +
          @total_deposits -
          @total_withdrawals

    end
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_account
      @bank_account =
        BankAccount.includes(:bank)
                  .find(params[:id])
    end

    def set_active_link
      @active_link = "banks"
    end

    # Only allow a list of trusted parameters through.
    def bank_params
      params.require(:bank).permit(:name)
    end
end
