class SalePayment < ApplicationRecord
  belongs_to :customer
  belongs_to :sale, optional: true

  has_many :payment_allocations,
           dependent: :restrict_with_error

  has_many :allocated_sales,
           through: :payment_allocations,
           source: :sale

  enum :mode_of_payment, {
    cash: 0,
    momopay: 1,
    airtelpay: 2,
    bank: 3
  }

  validates :amount,
            numericality: { greater_than: 0 }

  validates :receipt_number,
            presence: true,
            uniqueness: true

  validates :invoice_reference,
            presence: true

  validates :payment_date,
            presence: true

  before_validation :set_payment_date, on: :create
  before_validation :set_customer_from_sale, on: :create
  before_validation :set_invoice_reference, on: :create
  before_validation :generate_receipt_number, on: :create

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
  def allocated_amount
    payment_allocations.sum(:amount)
  end

  def available_amount
    amount.to_d - allocated_amount.to_d
  end

  def fully_allocated?
    available_amount <= 0
  end

  def partially_allocated?
    allocated_amount.positive? && available_amount.positive?
  end

  def allocation_status
    if fully_allocated?
      "Fully Allocated"
    elsif partially_allocated?
      "Partially Allocated"
    else
      "Unallocated"
    end
  end

  def self.next_receipt_number
    year = Date.current.year
    month = Date.current.strftime("%m")
    prefix = "RPT/#{year}/#{month}/"

    last_payment = where(
      "receipt_number LIKE ?",
      "#{prefix}%"
    ).order(id: :desc).first

    last_number =
      last_payment&.receipt_number
        .to_s
        .split("/")
        .last
        .to_i

    next_number = last_number + 1

    "#{prefix}#{next_number.to_s.rjust(5, '0')}"
  end

  private

  def set_payment_date
    self.payment_date ||= Date.current
  end

  def set_customer_from_sale
    self.customer ||= sale&.customer
  end

  def set_invoice_reference
    return if invoice_reference.present?
    return if sale.blank?

    previous_payment = sale.sale_payments
                           .where.not(id: id)
                           .order(id: :desc)
                           .first

    self.invoice_reference =
      previous_payment&.receipt_number ||
      sale.invoice_no
  end

  def generate_receipt_number
    self.receipt_number ||= self.class.next_receipt_number
  end
end