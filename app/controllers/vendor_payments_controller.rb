class VendorPaymentsController < ApplicationController
  before_action :set_vendor_payment, only: %i[ show edit update destroy ]
  
  # GET /vendor_payments or /vendor_payments.json
  def index
    @vendor_payments = VendorPayment.all
  end

  # GET /vendor_payments/1 or /vendor_payments/1.json
  def show
  end

  # GET /vendor_payments/new
  def new
    @active_link='payments'
    @vendor_payment = VendorPayment.new
  end

  # GET /vendor_payments/1/edit
  def edit
    @active_link='payments'
  end

  # POST /vendor_payments or /vendor_payments.json
  def create
    @active_link='payments'
    @vendor_payment = VendorPayment.new(vendor_payment_params)

    respond_to do |format|
      if @vendor_payment.save
        format.html { redirect_to statements_payments_path, notice: "Vendor payment was successfully created." }
        format.json { render :show, status: :created, location: @vendor_payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vendor_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendor_payments/1 or /vendor_payments/1.json
  def update
    @active_link='payments'
    respond_to do |format|
      if @vendor_payment.update(vendor_payment_params)
        format.html { redirect_to statements_payments_path, notice: "Vendor payment was successfully updated." }
        format.json { render :show, status: :ok, location: @vendor_payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vendor_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendor_payments/1 or /vendor_payments/1.json
  def destroy
    @vendor_payment.destroy!

    respond_to do |format|
      format.html { redirect_to statements_payments_path, status: :see_other, notice: "Vendor payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor_payment
      @vendor_payment = VendorPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_payment_params
      params.require(:vendor_payment).permit(:territory_id, :user_id, :payment_date, :journal_no, :ref_no, :payments, :suspence)
    end
end
