class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]
  before_action :set_active_link
  # GET /payments or /payments.json
  def index
    @territory = Territory.find(current_territory.id)
    @payments = @territory.payments.page(params[:page]).per(10).order(payment_date: :desc)
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new(payment_date: DateTime.now)
    @territory = Territory.find(current_territory.id)
    @employees = @territory.employees
    @suppliers = Supplier.all
    @bank_accounts = @territory.bank_accounts
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    params[:payment][:recipient_type] = params[:payment][:recipient_type].classify
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payments_path, notice: "Payment was successfully created." }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to payments_path, notice: "Payment was successfully updated." }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy!

    respond_to do |format|
      format.html { redirect_to payments_path, status: :see_other, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def set_active_link
      @active_link = "payments"
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:territory_id, :user_id, :bank_account_id, :recipient_id, :recipient_type, :payment_method, :amount, :payment_date, :payment_ref, :payment_no)
    end
end
