class VendorPayment < ApplicationRecord
  belongs_to :territory
  belongs_to :user

  enum :payment_method, {
    cash: 0,
    bank: 1,
    cheque: 2,
    mobile_money: 3
  }

  enum :status, {
    pending: 0,
    reconciled: 1
  }

  validates :payment_date, :amount, presence: true
  validates :amount,
            numericality: {
              greater_than: 0
            }

  before_validation :generate_payment_number,
                    on: :create

  ##################################################
  # Search
  ##################################################

  def self.search(params)
    query = all

    # Search
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "payment_no LIKE :search
        OR journal_no LIKE :search
        OR ref_no LIKE :search
        OR notes LIKE :search",
        search: search
      )
    end

    # From Date
    if params[:start_date].present?
      query = query.where(
        "DATE(payment_date) >= ?",
        params[:start_date]
      )
    end

    # To Date
    if params[:end_date].present?
      query = query.where(
        "DATE(payment_date) <= ?",
        params[:end_date]
      )
    end

    # Payment Method
    if params[:payment_method].present?
      query = query.where(
        payment_method: payment_methods[params[:payment_method]]
      )
    end

    query
  end

  ##################################################
  # Helpers
  ##################################################

  def formatted_amount
    ActionController::Base.helpers.number_with_delimiter(amount)
  end

  def payment_method_name
    payment_method.titleize
  end

  private

  ##################################################
  # Payment Number
  ##################################################

  def generate_payment_number
    return if payment_no.present?

    date = payment_date || Date.current

    prefix =
      "VPY/#{date.year}/#{date.strftime('%m')}/"

    last_payment =
      self.class
          .where(
            "payment_no LIKE ?",
            "#{prefix}%"
          )
          .order(id: :desc)
          .first

    last_number =
      last_payment
        &.payment_no
        &.split("/")
        &.last
        &.to_i || 0

    self.payment_no =
      "#{prefix}#{(last_number + 1).to_s.rjust(5, '0')}"
  end
end