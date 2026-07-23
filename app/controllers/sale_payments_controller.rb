class SalePaymentsController < ApplicationController
  before_action :set_sale, only: %i[new create show edit update]
  before_action :set_sale_payment, only: %i[edit update destroy]

  def index
    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= Date.current.to_s

    filtered_payments = SalePayment.search(params)

    @sale_payments = filtered_payments
                       .includes(
                         :customer,
                         :sale,
                         :payment_allocations
                       )
                       .order(payment_date: :desc, id: :desc)
                       .page(params[:page])
                       .per(20)

    @total_paid = filtered_payments.sum(:amount)

    sale_ids = filtered_payments
                 .reorder(nil)
                 .where.not(sale_id: nil)
                 .distinct
                 .pluck(:sale_id)

    filtered_sales = Sale
                       .includes(:sale_items, :payment_allocations)
                       .where(id: sale_ids)

    @total_invoiced = filtered_sales.sum do |sale|
      sale.adjusted_invoice_amount.to_d
    end

    @total_balance = filtered_sales.sum do |sale|
      sale.balance.to_d
    end

    @active_link = "sale_payments"
  end

  def show
    @active_link = "sale_payments"
    @sale_payment = SalePayment
                      .includes(
                        :customer,
                        :sale,
                        payment_allocations: :sale
                      )
                      .find(params[:id])

    @sale = @sale_payment.sale
  end

  def new
    @active_link = "sale_payments"
    @sale_payment = @sale.original_sale_payments.new(
      customer: @sale.customer,
      payment_date: Date.current
    )

    last_payment = @sale
                     .original_sale_payments
                     .order(id: :desc)
                     .first

    @sale_payment.invoice_reference =
      last_payment&.receipt_number || @sale.invoice_no

    @sale_payment.receipt_number =
      SalePayment.next_receipt_number
  end

  def create
    @active_link = "sale_payments"
    @sale_payment = @sale.original_sale_payments.new(
      sale_payment_params
    )

    @sale_payment.customer = @sale.customer
    @sale_payment.sale = @sale

    ActiveRecord::Base.transaction do
      @sale_payment.save!

      Payments::AllocateSalePayment.new(
        sale_payment: @sale_payment,
        preferred_sale: @sale
      ).call
    end

    redirect_to sale_sale_payment_path(
                  @sale,
                  @sale_payment
                ),
                notice: "Payment saved successfully."

  rescue ActiveRecord::RecordInvalid => error
    if error.record.is_a?(SalePayment)
      @sale_payment = error.record
    else
      @sale_payment.errors.add(
        :base,
        error.record.errors.full_messages.to_sentence
      )
    end

    render :new,
           status: :unprocessable_entity
  end

  def edit
    @active_link = "sale_payments"
  end

  def update
    @active_link = "sale_payments"
    if @sale_payment.update(sale_payment_params)
      redirect_to sale_sale_payment_path(
                    @sale,
                    @sale_payment
                  ),
                  notice: "Sale payment was successfully updated."
    else
      render :edit,
             status: :unprocessable_entity
    end
  end

  def destroy
    @sale_payment.destroy!

    redirect_to sale_payments_path,
                status: :see_other,
                notice: "Sale payment was successfully destroyed."
  end

  def receipt_pdf
    @sale_payment = SalePayment
                      .includes(
                        :customer,
                        :sale,
                        payment_allocations: :sale
                      )
                      .find(params[:id])

    @sale = @sale_payment.sale
    @payment = @sale_payment

    respond_to do |format|
      format.html

      format.pdf do
        render pdf: "receipt-#{@sale_payment.receipt_number}",
               template: "sale_payments/receipt_pdf",
               formats: [:html],
               disposition: :inline,
               layout: "pdf"
      end
    end
  end

  private

  def set_sale
    @sale = Sale.find(params[:sale_id])
  end

  def set_sale_payment
    @sale_payment = SalePayment
                      .includes(
                        :customer,
                        :sale,
                        payment_allocations: :sale
                      )
                      .find(params[:id])

    @sale ||= @sale_payment.sale
  end

  def sale_payment_params
    params.require(:sale_payment).permit(
      :amount,
      :payment_date,
      :mode_of_payment,
      :notes
    )
  end
end