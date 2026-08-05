class VendorAdjustiment < ApplicationRecord
  belongs_to :territory
  belongs_to :user
  belongs_to :purchase_type

  enum :adjustment_type, {
    debit: "debit",
    credit: "credit"
  }

  enum :adjustment_category, {
    manual: "manual",
    payment_incentive: "payment_incentive",
    warehouse_incentive: "warehouse_incentive",
    rebate: "rebate"
  }

  before_validation :generate_journal_number, on: :create

  def self.search(params)
    query = all

    # Search
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "journal_no LIKE :search
         OR ref_no LIKE :search
         OR description LIKE :search",
        search: search
      )
    end

    # From Date
    if params[:start_date].present?
      query = query.where(
        "DATE(adjustment_date) >= ?",
        params[:start_date]
      )
    end

    # To Date
    if params[:end_date].present?
      query = query.where(
        "DATE(adjustment_date) <= ?",
        params[:end_date]
      )
    end

    query
  end

  validates :adjustment_date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  private

  def generate_journal_number
    return if journal_no.present?

    date = adjustment_date || Date.current

    prefix = "VJ/#{date.strftime('%Y')}/#{date.strftime('%m')}/"

    last_adjustment = VendorAdjustiment
                        .where("journal_no LIKE ?", "#{prefix}%")
                        .order(:id)
                        .last

    last_number =
      last_adjustment&.journal_no
                     &.split("/")
                     &.last
                     &.to_i || 0

    self.journal_no =
      "#{prefix}#{(last_number + 1).to_s.rjust(5, '0')}"
  end
end