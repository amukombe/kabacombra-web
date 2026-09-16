class CustomerPaymentsController < ApplicationController

  before_action :set_customer_payment,
                only: %i[
                  show
                  edit
                  update
                  destroy
                  auto_allocate
                ]

  before_action :set_active_link

  # ============================================================
  # INDEX
  # ============================================================

  def index

    @customer_payments =
      current_territory
        .customer_payments
        .includes(
          :customer,
          :user
        )
        .order(
          payment_date: :desc,
          created_at: :desc
        )

  end


  # ============================================================
  # NEW
  # ============================================================

  # GET /customer_payments/new
  def new
    @active_link = "payments"

    @customer_payment =
        CustomerPayment.new(
        payment_date: Date.current,
        payment_method: :cash
        )

    if params[:customer_id].present?
        @customer_payment.customer =
        current_territory.customers.find(params[:customer_id])
    end
    @customers = current_territory.customers
  end


  # ============================================================
  # CREATE
  # ============================================================

  def create

    @customer_payment =
      current_territory
        .customer_payments
        .new(
          customer_payment_params
        )

    @customer_payment.user =
      current_user

    @customer_payment.territory =
      current_territory

    if @customer_payment.save

      redirect_to edit_customer_payment_path(
        @customer_payment
      ),
      notice: "Payment created. Allocate the payment to invoices."

    else

      @customers =
        current_territory
          .customers
          .order(:name)

      render :new,
             status: :unprocessable_entity

    end

  end


  # ============================================================
  # SHOW
  # ============================================================

  def show

    @allocations =
      @customer_payment
        .payment_allocations
        .includes(:sale)
        .order(:allocated_at)

  end


  # ============================================================
  # EDIT
  # ============================================================

  def edit

    @customers =
      current_territory
        .customers
        .order(:name)

    load_outstanding_sales

  end


  # ============================================================
  # UPDATE
  # ============================================================

  def update

    if @customer_payment.update(
      customer_payment_params
    )

      redirect_to edit_customer_payment_path(
        @customer_payment
      ),
      notice: "Payment updated. Review the invoice allocations."

    else

      @customers =
        current_territory
          .customers
          .order(:name)

      load_outstanding_sales

      render :edit,
             status: :unprocessable_entity

    end

  end


  # ============================================================
  # AUTO ALLOCATE
  # ============================================================

  def auto_allocate

    if @customer_payment.amount.to_d <= 0

      redirect_to edit_customer_payment_path(
        @customer_payment
      ),
      alert: "Payment amount must be greater than zero."

      return
    end

    remaining =
      @customer_payment.amount.to_d

    # Remove existing allocations before recalculating.
    @customer_payment
      .payment_allocations
      .destroy_all

    sales =
      customer_outstanding_sales
        .order(
          created_at: :asc,
          id: :asc
        )

    sales.each do |sale|

      break if remaining <= 0

      outstanding =
        sale_customer_outstanding_amount(
          sale
        )

      next if outstanding <= 0

      allocation =
        [remaining, outstanding].min

      @customer_payment
        .payment_allocations
        .create!(
          sale: sale,
          amount: allocation,
          allocated_at: Time.current
        )

      remaining -= allocation

    end

    @customer_payment.update!(
      allocated_amount:
        @customer_payment
          .payment_allocations
          .sum(:amount),

      credit_amount:
        remaining
    )

    redirect_to edit_customer_payment_path(
      @customer_payment
    ),
    notice: "Payment automatically allocated to outstanding invoices."

  rescue ActiveRecord::RecordInvalid => e

    redirect_to edit_customer_payment_path(
      @customer_payment
    ),
    alert: e.message

  end


  # ============================================================
  # DESTROY
  # ============================================================

  def destroy

    @customer_payment.destroy!

    redirect_to customer_payments_path,
                notice: "Customer payment deleted successfully."

  end


  private


  # ============================================================
  # SET PAYMENT
  # ============================================================

  def set_customer_payment

    @customer_payment =
      current_territory
        .customer_payments
        .find(params[:id])

  end


  # ============================================================
  # ACTIVE LINK
  # ============================================================

  def set_active_link

    @active_link = "payments"

  end


  # ============================================================
  # STRONG PARAMETERS
  # ============================================================

  def customer_payment_params

    params
      .require(:customer_payment)
      .permit(
        :customer_id,
        :payment_no,
        :payment_date,
        :payment_method,
        :amount,
        :payment_ref,
        :notes
      )

  end


  # ============================================================
  # OUTSTANDING SALES
  # ============================================================

  def customer_outstanding_sales
    @customer_payment
        .customer
        .sales
        .select do |sale|
        sale_customer_outstanding_amount(sale) > 0
        end
    end


  # ============================================================
  # OUTSTANDING AMOUNT
  # ============================================================

  def sale_customer_outstanding_amount(sale)

    customer_payments =
        sale
        .customer_payment_allocations
        .where
        .not(
            customer_payment_id:
            @customer_payment.id
        )
        .sum(:amount)

    sale_payments =
        sale
        .sale_payments
        .sum(:amount)

    total_paid =
        customer_payments.to_d +
        sale_payments.to_d

    sale.total_price.to_d -
        total_paid

    end

  # ============================================================
  # LOAD OUTSTANDING SALES
  # ============================================================

  def load_outstanding_sales

    @outstanding_sales =
      customer_outstanding_sales

  end

end