class SalePayment < ApplicationRecord
  belongs_to :sale

  enum :mode_of_payment, {
    cash: 0,
    momopay: 1,
    airtelpay: 2,
    bank: 3
  }

  validates :amount, numericality: { greater_than: 0 }
  validates :receipt_number, presence: true, uniqueness: true
  validates :invoice_reference, presence: true

  before_validation :set_payment_date, on: :create
  before_validation :set_invoice_reference, on: :create
  before_validation :generate_receipt_number, on: :create
  before_validation :set_balances, on: :create

  validate :amount_cannot_exceed_balance
  before_validation :generate_receipt_number, on: :create
  before_validation :set_invoice_reference, on: :create

  def self.search(params)
    query = all

    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.joins(:sale).where(
        "sale_payments.receipt_number LIKE :search
        OR sale_payments.invoice_reference LIKE :search
        OR sales.invoice_no LIKE :search
        OR sales.receipt_no LIKE :search
        OR sales.customer_name LIKE :search
        OR sales.customer_mobile LIKE :search
        OR sale_payments.mode_of_payment LIKE :search",
        search: search
      )
    end

    if params[:start_date].present?
      query = query.where(
        "DATE(sale_payments.payment_date) >= ?",
        params[:start_date]
      )
    end

    if params[:end_date].present?
      query = query.where(
        "DATE(sale_payments.payment_date) <= ?",
        params[:end_date]
      )
    end

    query
  end
  def self.next_receipt_number
    year  = Date.current.year
    month = Date.current.strftime("%m")

    last_payment = SalePayment
                     .where("receipt_number LIKE ?", "RPT/#{year}/#{month}/%")
                     .order(id: :desc)
                     .first

    last_number =
      if last_payment.present?
        last_payment.receipt_number.split("/").last.to_i
      else
        0
      end

    next_number = last_number + 1

    "RPT/#{year}/#{month}/#{next_number.to_s.rjust(5, '0')}"
  end

  
  private
  def set_invoice_reference
    last_payment = sale.sale_payments.order(id: :desc).first

    self.invoice_reference =
      if last_payment.present?
        last_payment.receipt_number
      else
        sale.invoice_no
      end
  end

  def set_payment_date
    self.payment_date ||= Date.current
  end

  def set_balances
    self.balance_before = sale.balance
    self.balance_after = balance_before - amount.to_d
  end

  def amount_cannot_exceed_balance
    return if sale.blank?

    if amount.to_d > sale.balance
      errors.add(:amount, "cannot be greater than remaining balance")
    end
  end

  def generate_receipt_number
    self.receipt_number ||= SalePayment.next_receipt_number
  end
end