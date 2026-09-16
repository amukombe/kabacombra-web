class CustomerPaymentAllocation < ApplicationRecord

  belongs_to :customer_payment

  belongs_to :sale

  validates :amount,
            presence: true,
            numericality: {
              greater_than: 0
            }

  validates :allocated_at,
            presence: true

  validate :amount_cannot_exceed_sale_balance

  private

  def amount_cannot_exceed_sale_balance

    return if sale.blank?

    existing_allocated =
      sale
        .customer_payment_allocations
        .where
        .not(id: id)
        .sum(:amount)

    sale_total =
      sale.total_amount.to_d

    outstanding =
      sale_total -
      existing_allocated.to_d

    if amount.to_d > outstanding

      errors.add(
        :amount,
        "cannot exceed the outstanding invoice balance"
      )

    end

  end

end