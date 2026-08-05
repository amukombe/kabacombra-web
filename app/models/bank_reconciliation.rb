class BankReconciliation < ApplicationRecord
  belongs_to :territory
  belongs_to :user
  belongs_to :bank_account
  has_one_attached :statement_file
  has_many :bank_reconciliation_items, dependent: :destroy

  accepts_nested_attributes_for :bank_reconciliation_items,
                                allow_destroy: true

  enum :status, {
    draft: "draft",
    reconciled: "reconciled",
    approved: "approved"
  }

  validates :statement_from,
            :statement_to,
            presence: true

  before_validation :generate_reference,
                    on: :create

  private

  def generate_reference
    return if reference.present?

    year  = Date.current.year
    month = Date.current.strftime("%m")

    prefix = "BRC/#{year}/#{month}/"

    last =
      self.class
          .where("reference LIKE ?", "#{prefix}%")
          .order(id: :desc)
          .first

    number =
      last
        &.reference
        &.split("/")
        &.last
        &.to_i || 0

    self.reference =
      "#{prefix}#{(number + 1).to_s.rjust(5, '0')}"

    self.status ||= "draft"
  end
end