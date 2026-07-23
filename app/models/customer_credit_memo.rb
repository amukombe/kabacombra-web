class CustomerCreditMemo < ApplicationRecord
  belongs_to :customer

  belongs_to :created_by,
             class_name: "User"

  belongs_to :approved_by,
             class_name: "User",
             optional: true

  has_many :credit_memo_allocations,
           dependent: :restrict_with_error

  has_many :sales,
           through: :credit_memo_allocations

  enum :memo_type, {
    appreciation: "appreciation",
    reward: "reward",
    rebate: "rebate",
    promotion: "promotion",
    goodwill: "goodwill",
    loyalty_bonus: "loyalty_bonus",
    other: "other"
  }

  enum :status, {
    draft: "draft",
    approved: "approved",
    cancelled: "cancelled"
  }

  validates :memo_number,
            presence: true,
            uniqueness: true

  validates :memo_date,
            presence: true

  validates :memo_type,
            presence: true

  validates :reason,
            presence: true

  validates :amount,
            numericality: { greater_than: 0 }

  before_validation :set_defaults,
                    on: :create

  before_validation :generate_memo_number,
                    on: :create

  def allocated_amount
    credit_memo_allocations.sum(:amount)
  end

  def available_amount
    return 0.to_d unless approved?

    amount.to_d - allocated_amount.to_d
  end

  def fully_allocated?
    available_amount <= 0
  end

  def approve!(user)
    raise ActiveRecord::RecordInvalid, self unless draft?

    update!(
      status: "approved",
      approved_by: user,
      approved_at: Time.current
    )
  end

  def cancel!
    if credit_memo_allocations.exists?
      errors.add(
        :base,
        "Cannot cancel a credit memo that has already been applied"
      )

      raise ActiveRecord::RecordInvalid, self
    end

    update!(status: "cancelled")
  end

  def self.next_memo_number
    year = Date.current.year
    month = Date.current.strftime("%m")
    prefix = "CM/#{year}/#{month}/"

    last_memo = where(
      "memo_number LIKE ?",
      "#{prefix}%"
    ).order(id: :desc).first

    last_number =
      last_memo&.memo_number
        .to_s
        .split("/")
        .last
        .to_i

    next_number = last_number + 1

    "#{prefix}#{next_number.to_s.rjust(5, '0')}"
  end

  private

  def set_defaults
    self.memo_date ||= Date.current
    self.status ||= "draft"
  end

  def generate_memo_number
    self.memo_number ||= self.class.next_memo_number
  end
end