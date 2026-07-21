class CustomerAdjustment < ApplicationRecord
  belongs_to :sale
  belongs_to :customer

  belongs_to :created_by, class_name: "User"

  belongs_to :approved_by, class_name: "User", optional: true

  has_many :customer_adjustment_items, dependent: :destroy

  accepts_nested_attributes_for :customer_adjustment_items, allow_destroy: true, reject_if: :all_blank

  enum :adjustment_type, {
    credit_note: "credit_note",
    debit_note: "debit_note"
  }

  enum :status, {
    draft: "draft",
    approved: "approved",
    cancelled: "cancelled"
  }

  validates :adjustment_type, presence: true
  validates :adjustment_date, presence: true
  validates :adjustment_number, presence: true, uniqueness: true
  validates :reason, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_defaults, on: :create
  before_validation :generate_adjustment_number, on: :create
  before_validation :calculate_totals

  validate :customer_matches_sale
  validate :must_have_items
  validate :applied_amount_cannot_exceed_total

  scope :active, -> { where.not(status: "cancelled") }

  def self.search(params)
    query = all

    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query
                .left_joins(:customer, :sale)
                .where(
                  "customer_adjustments.adjustment_number LIKE :search
                   OR customer_adjustments.reason LIKE :search
                   OR customer_adjustments.adjustment_type LIKE :search
                   OR customer_adjustments.status LIKE :search
                   OR sales.invoice_no LIKE :search
                   OR customers.name LIKE :search",
                  search: search
                )
    end

    if params[:adjustment_type].present?
      query = query.where(
        customer_adjustments: {
          adjustment_type: params[:adjustment_type]
        }
      )
    end

    if params[:status].present?
      query = query.where(
        customer_adjustments: {
          status: params[:status]
        }
      )
    end

    if params[:start_date].present?
      query = query.where(
        "DATE(customer_adjustments.adjustment_date) >= ?",
        params[:start_date]
      )
    end

    if params[:end_date].present?
      query = query.where(
        "DATE(customer_adjustments.adjustment_date) <= ?",
        params[:end_date]
      )
    end

    query
  end

  def remaining_amount
    total_amount.to_d - applied_amount.to_d
  end

  def fully_applied?
    remaining_amount <= 0
  end

  def approve!(user)
    transaction do
      calculate_totals

      update!(
        status: "approved",
        approved_by: user,
        approved_at: Time.current
      )
    end
  end

  def cancel!
    update!(status: "cancelled")
  end

  private

  def set_defaults
    self.adjustment_date ||= Date.current
    self.customer ||= sale&.customer
    self.status ||= "draft"
  end

  def calculate_totals
    active_items = customer_adjustment_items.reject(&:marked_for_destruction?)

    self.subtotal = active_items.sum do |item|
      item.quantity.to_d * item.unit_price.to_d
    end

    self.discount_total = active_items.sum do |item|
      item.discount_amount.to_d
    end

    self.tax_total = active_items.sum do |item|
      item.tax_amount.to_d
    end

    self.total_amount =
      subtotal.to_d -
      discount_total.to_d +
      tax_total.to_d
  end

  def customer_matches_sale
    return if customer.blank? || sale.blank?

    if customer_id != sale.customer_id
      errors.add(:customer, "must be the same customer as the selected sale")
    end
  end

  def must_have_items
    active_items = customer_adjustment_items.reject(&:marked_for_destruction?)

    if active_items.empty?
      errors.add(:base, "Add at least one adjustment item")
    end
  end

  def applied_amount_cannot_exceed_total
    if applied_amount.to_d > total_amount.to_d
      errors.add(
        :applied_amount,
        "cannot exceed the adjustment total"
      )
    end
  end

  def generate_adjustment_number
    return if adjustment_number.present?

    prefix = credit_note? ? "CN" : "DN"
    year = Date.current.year
    month = Date.current.strftime("%m")

    number_prefix = "#{prefix}/#{year}/#{month}/"

    last_adjustment = CustomerAdjustment
                        .where(
                          "adjustment_number LIKE ?",
                          "#{number_prefix}%"
                        )
                        .order(id: :desc)
                        .first

    last_number =
      last_adjustment&.adjustment_number
        .to_s
        .split("/")
        .last
        .to_i

    next_number = last_number + 1

    self.adjustment_number =
      "#{number_prefix}#{next_number.to_s.rjust(5, '0')}"
  end
end