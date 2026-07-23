class CreditMemoAllocation < ApplicationRecord
  belongs_to :customer_credit_memo
  belongs_to :sale

  validates :amount,
            numericality: { greater_than: 0 }

  validates :allocated_at,
            presence: true

  before_validation :set_allocated_at,
                    on: :create

  validate :credit_memo_must_be_approved
  validate :customer_must_match
  validate :amount_cannot_exceed_available_credit
  validate :amount_cannot_exceed_sale_balance

  private

  def set_allocated_at
    self.allocated_at ||= Time.current
  end

  def credit_memo_must_be_approved
    return if customer_credit_memo.blank?
    return if customer_credit_memo.approved?

    errors.add(
      :customer_credit_memo,
      "must be approved before it can be applied"
    )
  end

  def customer_must_match
    return if customer_credit_memo.blank? || sale.blank?

    if customer_credit_memo.customer_id != sale.customer_id
      errors.add(
        :sale,
        "must belong to the credit memo customer"
      )
    end
  end

  def amount_cannot_exceed_available_credit
    return if customer_credit_memo.blank?

    other_allocations =
      customer_credit_memo
        .credit_memo_allocations
        .where.not(id: id)
        .sum(:amount)

    available =
      customer_credit_memo.amount.to_d -
      other_allocations.to_d

    if amount.to_d > available
      errors.add(
        :amount,
        "cannot exceed the available credit of UGX #{available}"
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