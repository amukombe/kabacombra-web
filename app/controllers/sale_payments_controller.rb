class SalePaymentsController < ApplicationController
  before_action :set_sale_payment, only: %i[ show edit update destroy ]
  before_action :set_sale, only: %i[ show edit update create edit new]

  # GET /sale_payments or /sale_payments.json
  def index
    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= Date.current.to_s

    @sale_payments = SalePayment
                      .includes(:sale)
                      .search(params)
                      .order(payment_date: :desc, id: :desc)
                      .page(params[:page])
                      .per(20)
    filtered_payments = SalePayment
                        .includes(sale: :sale_items)
                        .search(params)
    @total_paid = SalePayment.search(params).sum(:amount)
    sales = Sale.search(params)
    sale_ids = filtered_payments
               .reorder(nil)
               .distinct
               .pluck(:sale_id)

    @total_invoiced = SaleItem
                        .where(sale_id: sale_ids)
                        .sum(:total)
    @total_balance = @total_invoiced - @total_paid

    @active_link = "sale_payments"
  end

  # GET /sale_payments/1 or /sale_payments/1.json
  def show
  end

  # GET /sale_payments/new
  def new
    @sale_payment = SalePayment.new
    # Invoice Reference
    last_payment = @sale.sale_payments.order(id: :desc).first

    @sale_payment.invoice_reference =
      if last_payment.present?
        last_payment.receipt_number
      else
        @sale.invoice_no
      end

    # Preview next Receipt Number
    @sale_payment.receipt_number = SalePayment.next_receipt_number
  end

  # GET /sale_payments/1/edit
  def edit
  end

  # POST /sale_payments or /sale_payments.json
  def create
    @sale_payment = SalePayment.new(sale_payment_params)

    respond_to do |format|
      if @sale_payment.save
        format.html { redirect_to sale_payments_path, notice: "Sale payment was successfully created." }
        format.json { render :show, status: :created, location: @sale_payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_payments/1 or /sale_payments/1.json
  def update
    respond_to do |format|
      if @sale_payment.update(sale_payment_params)
        format.html { redirect_to @sale_payment, notice: "Sale payment was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_payments/1 or /sale_payments/1.json
  def destroy
    @sale_payment.destroy!

    respond_to do |format|
      format.html { redirect_to sale_payments_path, status: :see_other, notice: "Sale payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def receipt_pdf
    @payment = SalePayment.find(params[:id]) 
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "sale_payments/receipt_pdf", formats: [:html], disposition: :inline, layout: 'pdf'   # Excluding ".pdf" extension.
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_payment
      @sale_payment = SalePayment.find(params[:id])
    end

    def set_sale
      @sale = Sale.find(params[:sale_id])
    end
    # Only allow a list of trusted parameters through.
    def sale_payment_params
      params.require(:sale_payment).permit(:sale_id, :invoice_reference, :receipt_number, :amount, :payment_date, :mode_of_payment, :balance_before, :balance_after, :notes)
    end
end
