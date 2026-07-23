class Customer < ApplicationRecord
    belongs_to :territory
    has_many :sales, dependent: :destroy
    has_many :customer_adjustments, dependent: :restrict_with_error
    has_many :credit_notes, -> { where(adjustment_type: "credit_note") }, class_name: "CustomerAdjustment"
    has_many :debit_notes, -> { where(adjustment_type: "debit_note") }, class_name: "CustomerAdjustment"
    has_many :sale_payments, dependent: :restrict_with_error
    has_many :customer_credit_memos, dependent: :restrict_with_error
    has_many :customer_adjustments, dependent: :restrict_with_error
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end

    def total_invoiced
    sales.includes(:sale_items).sum do |sale|
      sale.total_price.to_d
    end
  end

  def total_debit_notes
    customer_adjustments
      .approved
      .debit_note
      .sum(:total_amount)
  end

  def total_credit_notes
    customer_adjustments
      .approved
      .credit_note
      .sum(:total_amount)
  end

  def total_payments
    sale_payments.sum(:amount)
  end

  def total_allocated_payments
    PaymentAllocation
      .joins(:sale_payment)
      .where(
        sale_payments: {
          customer_id: id
        }
      )
      .sum(:amount)
  end

  def outstanding_balance
    sales.includes(
      :sale_items,
      :payment_allocations,
      :customer_adjustments
    ).sum do |sale|
      [sale.balance.to_d, 0].max
    end
  end

  def net_account_balance
    outstanding_balance.to_d - available_credit.to_d
  end

  def available_payment_credit
    sale_payments
        .includes(:payment_allocations)
        .sum do |payment|
        payment.available_amount.to_d
        end
    end

    def available_credit_memos
    customer_credit_memos
        .approved
        .includes(:credit_memo_allocations)
        .sum do |memo|
        memo.available_amount.to_d
        end
    end

    def available_credit
    available_payment_credit.to_d +
        available_credit_memos.to_d
    end
end
