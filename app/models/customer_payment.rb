class CustomerPayment < ApplicationRecord

  belongs_to :customer
  belongs_to :territory
  belongs_to :user

  has_many :payment_allocations,
           class_name: "CustomerPaymentAllocation",
           dependent: :destroy

  has_many :sales,
           through: :payment_allocations

  enum payment_method: {
    cash: 0,
    cheque: 1,
    mobile_money: 2,
    bank_transfer: 3
  }

  validates :customer,
            presence: true

  validates :territory,
            presence: true

  validates :user,
            presence: true

  validates :payment_no,
            presence: true,
            uniqueness: true

  validates :payment_date,
            presence: true

  validates :payment_method,
            presence: true

  validates :amount,
            presence: true,
            numericality: {
              greater_than: 0
            }

  def total_allocated
    payment_allocations.sum(:amount)
  end

  def unallocated_amount
    amount.to_d - total_allocated.to_d
  end

  def fully_allocated?
    unallocated_amount <= 0
  end

end