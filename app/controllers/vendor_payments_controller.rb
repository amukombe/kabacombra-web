class VendorPaymentsController < ApplicationController
  before_action :set_vendor_payment,
                only: %i[
                  show
                  edit
                  update
                  destroy
                ]

  ####################################################
  # INDEX
  ####################################################

  def index
    @active_link = "payments"

    params[:start_date] ||= Date.current.beginning_of_month.to_s
    params[:end_date] ||= Date.current.to_s

    filtered_payments =
      current_territory
        .vendor_payments
        .search(params)
        .order(payment_date: :desc, id: :desc)

    @vendor_payments =
      filtered_payments
        .page(params[:page])
        .per(20)

    ##################################################
    # Summary Cards
    ##################################################

    @payment_count =
      filtered_payments.count

    @total_paid =
      filtered_payments.sum(:amount)

    @total_suspense =
      filtered_payments.sum(:suspense_amount)

    @cash_out =
      @total_paid.to_d +
      @total_suspense.to_d

    @average_payment =
      @payment_count.zero? ? 0 : (@total_paid / @payment_count)

    ##################################################
    # Payment Method Summary
    ##################################################

    @cash_total =
      filtered_payments.cash.sum(:amount)

    @bank_total =
      filtered_payments.bank.sum(:amount)

    @cheque_total =
      filtered_payments.cheque.sum(:amount)

    @mobile_money_total =
      filtered_payments.mobile_money.sum(:amount)

    ##################################################
    # Vendor Incentives
    ##################################################

    adjustments =
      VendorAdjustiment.where(
        adjustment_date:
          params[:start_date]..params[:end_date],
        territory: current_territory
      )

    @payment_incentives =
      adjustments
        .payment_incentive
        .sum(:amount)

    @warehouse_incentives =
      adjustments
        .warehouse_incentive
        .sum(:amount)

    @rebates =
      adjustments
        .rebate
        .sum(:amount)

    @manual_adjustments =
      adjustments
        .manual
        .sum(:amount)

    @total_adjustments =
        @payment_incentives +
        @warehouse_incentives +
        @rebates +
        @manual_adjustments
  end

  ####################################################
  # SHOW
  ####################################################

  def show
    @active_link = "payments"
  end

  ####################################################
  # NEW
  ####################################################

  def new
    @active_link = "payments"

    @vendor_payment = VendorPayment.new(
      payment_date: Date.current,
      payment_method: :cash,
      suspense_amount: 0
    )
  end

  ####################################################
  # EDIT
  ####################################################

  def edit
    @active_link = "payments"
  end

  ####################################################
  # CREATE
  ####################################################

  def create
    @active_link = "payments"

    @vendor_payment =
      VendorPayment.new(
        vendor_payment_params
      )

    @vendor_payment.user = current_user
    @vendor_payment.territory = current_territory

    respond_to do |format|

      begin

        ActiveRecord::Base.transaction do

          @vendor_payment.save!

          VendorAdjustiments::GenerateIncentives.new(
            @vendor_payment
          ).call

        end

        format.html do
          redirect_to vendor_payments_path,
                      notice: "Vendor payment was successfully created."
        end

        format.json do
          render :show,
                status: :created,
                location: @vendor_payment
        end

      rescue ActiveRecord::RecordInvalid => error

        @vendor_payment = error.record if error.record.is_a?(VendorPayment)

        format.html do
          render :new,
                status: :unprocessable_entity
        end

        format.json do
          render json: @vendor_payment.errors,
                status: :unprocessable_entity
        end

      end

    end
  end

  ####################################################
  # UPDATE
  ####################################################

  def update
    @active_link = "payments"

    respond_to do |format|

      if @vendor_payment.update(vendor_payment_params)

        format.html do
          redirect_to vendor_payments_path,
                      notice: "Vendor payment was successfully updated."
        end

        format.json do
          render :show,
                 status: :ok,
                 location: @vendor_payment
        end

      else

        format.html do
          render :edit,
                 status: :unprocessable_entity
        end

        format.json do
          render json: @vendor_payment.errors,
                 status: :unprocessable_entity
        end

      end

    end
  end

  ####################################################
  # DESTROY
  ####################################################

  def destroy
    @vendor_payment.destroy!

    respond_to do |format|

      format.html do
        redirect_to vendor_payments_path,
                    status: :see_other,
                    notice: "Vendor payment was successfully deleted."
      end

      format.json do
        head :no_content
      end

    end
  end

  def reconcile
    @vendor_payment = VendorPayment.find(params[:id])

    if @vendor_payment.pending?
      @vendor_payment.reconciled!

      redirect_to vendor_payments_path,
                  notice: "Payment reconciled successfully."
    else
      redirect_to vendor_payments_path,
                  alert: "This payment has already been reconciled."
    end
  end

  ####################################################
  private
  ####################################################

  def set_vendor_payment
    @vendor_payment =
      VendorPayment.find(params[:id])
  end

  def vendor_payment_params
    params.require(:vendor_payment).permit(
      :payment_date,
      :payment_method,
      :journal_no,
      :ref_no,
      :amount,
      :suspense_amount,
      :notes
    )
  end
end