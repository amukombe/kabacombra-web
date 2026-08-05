class StatementsController < ApplicationController
  before_action :set_default_dates

  def vendor_statement
    @active_link = "summary"

    load_period_records
    load_opening_balance
    load_summary
    build_ledger
  end

  def payments
    @active_link = "vendor_payments"

    @payments =
      VendorPayment
        .order(payment_date: :desc, id: :desc)

    if params[:start_date].present?
      @payments =
        @payments.where(
          "DATE(payment_date) >= ?",
          params[:start_date]
        )
    end

    if params[:end_date].present?
      @payments =
        @payments.where(
          "DATE(payment_date) <= ?",
          params[:end_date]
        )
    end

    if params[:query].present?
      search = "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"

      @payments =
        @payments.where(
          "payment_no LIKE :search
          OR journal_no LIKE :search
          OR ref_no LIKE :search",
          search: search
        )
    end

    @payment_count =
      @payments.count

    @total_paid =
      @payments.sum(:amount)

    @average_payment =
      @payment_count.zero? ? 0 : @total_paid / @payment_count

    @payments =
      @payments.page(params[:page]).per(20)
  end

  private

  def set_default_dates
    params[:start_date] ||= Date.current.beginning_of_month.to_s
    params[:end_date] ||= Date.current.to_s
  end

  def start_date
    Date.parse(params[:start_date])
  end

  def end_date
    Date.parse(params[:end_date])
  end

  def statement_date_range
    start_date..end_date
  end

  #############################################
  # Load all records within selected period
  #############################################

  def load_period_records
    @purchases =
      Inventory
        .where(
          created_at:
            start_date.beginning_of_day..
            end_date.end_of_day
        )

    @payments =
      VendorPayment
        .where(
          payment_date:
            statement_date_range
        )

    @adjustments =
      VendorAdjustiment
        .where(
          adjustment_date:
            statement_date_range
        )
  end

  #############################################
  # Opening Balance
  #############################################

  def load_opening_balance
    previous_purchases =
      Inventory
        .where(
          "DATE(created_at) < ?",
          start_date
        )

    previous_payments =
      VendorPayment
        .where(
          "payment_date < ?",
          start_date
        )

    previous_adjustments =
      VendorAdjustiment
        .where(
          "adjustment_date < ?",
          start_date
        )

    purchase_total =
      previous_purchases.sum(:total)

    payment_total =
      previous_payments.sum(:amount)

    debit_total =
      previous_adjustments
        .debit
        .sum(:amount)

    credit_total =
      previous_adjustments
        .credit
        .sum(:amount)

    @opening_balance =
      purchase_total +
      debit_total -
      payment_total -
      credit_total
  end

  #############################################
  # Summary
  #############################################

  def load_summary
    @purchase_total =
      @purchases.sum(:total)

    @payment_total =
      @payments.sum(:amount)

    @debit_adjustments =
      @adjustments
        .debit
        .sum(:amount)

    @credit_adjustments =
      @adjustments
        .credit
        .sum(:amount)

    @payment_incentives =
      @adjustments
        .payment_incentive
        .sum(:amount)

    @warehouse_incentives =
      @adjustments
        .warehouse_incentive
        .sum(:amount)

    @rebates =
      @adjustments
        .rebate
        .sum(:amount)

    @manual_adjustments =
      @adjustments
        .manual
        .sum(:amount)

    @adjustments_total =
      @debit_adjustments -
      @credit_adjustments

    @closing_balance =
      @opening_balance +
      @purchase_total +
      @debit_adjustments -
      @payment_total -
      @credit_adjustments
  end

  #############################################
  # Ledger
  #############################################

  def build_ledger
    transactions = []

    balance = @opening_balance

    transactions << {
      date: start_date,
      journal: "",
      reference: "",
      description: "Opening Balance",
      debit: 0,
      credit: 0,
      balance: balance
    }

    @purchases.each do |purchase|
      debit = purchase.total.to_d

      balance += debit

      transactions << {
        date: purchase.created_at.to_date,
        journal: purchase.id,
        reference: "",
        description: "Inventory Received",
        debit: debit,
        credit: 0,
        balance: balance
      }
    end

    @payments.each do |payment|
      credit = payment.amount.to_d

      balance -= credit

      transactions << {
        date: payment.payment_date,
        journal: payment.payment_no,
        reference: payment.ref_no,
        description: "Supplier Payment",
        debit: 0,
        credit: credit,
        balance: balance
      }
    end

    @adjustments.each do |adjustment|

      if adjustment.debit?

        debit = adjustment.amount.to_d

        balance += debit

        transactions << {
          date: adjustment.adjustment_date,
          journal: adjustment.journal_no,
          reference: adjustment.ref_no,
          description: adjustment.adjustment_category.titleize,
          debit: debit,
          credit: 0,
          balance: balance
        }

      else

        credit = adjustment.amount.to_d

        balance -= credit

        transactions << {
          date: adjustment.adjustment_date,
          journal: adjustment.journal_no,
          reference: adjustment.ref_no,
          description: adjustment.adjustment_category.titleize,
          debit: 0,
          credit: credit,
          balance: balance
        }

      end
    end

    @ledger =
      transactions.sort_by do |transaction|
        [
          transaction[:date],
          transaction[:journal].to_s
        ]
      end
  end
end
