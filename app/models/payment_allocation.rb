class PaymentAllocation < ApplicationRecord
  belongs_to :sale_payment
  belongs_to :sale

  validates :amount,
            numericality: { greater_than: 0 }

  validates :allocated_at,
            presence: true

  before_validation :set_allocated_at, on: :create

  validate :payment_and_sale_customer_must_match
  validate :amount_cannot_exceed_payment_available_amount
  validate :amount_cannot_exceed_sale_balance

  private

  def set_allocated_at
    self.allocated_at ||= Time.current
  end

  def payment_and_sale_customer_must_match
    return if sale_payment.blank? || sale.blank?

    if sale_payment.customer_id != sale.customer_id
      errors.add(
        :sale,
        "must belong to the same customer as the payment"
      )
    end
  end

  def amount_cannot_exceed_payment_available_amount
    return if sale_payment.blank?

    other_allocations = sale_payment
                          .payment_allocations
                          .where.not(id: id)
                          .sum(:amount)

    available =
      sale_payment.amount.to_d -
      other_allocations.to_d

    if amount.to_d > available
      errors.add(
        :amount,
        "cannot exceed available payment amount of UGX #{available}"
      )
    end
  end

  def amount_cannot_exceed_sale_balance
    return if sale.blank?

    existing_amount =
      persisted? ? amount_was.to_d : 0

    available_balance =
      sale.balance.to_d +
      existing_amount

    if amount.to_d > available_balance
      errors.add(
        :amount,
        "cannot exceed invoice balance of UGX #{available_balance}"
      )
    end
  end
end