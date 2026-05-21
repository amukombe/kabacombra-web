class Order < ApplicationRecord
  belongs_to :user
  belongs_to :status
  has_many :order_items, dependent: :destroy
  has_many :order_drivers, dependent: :destroy
  has_many :drivers, through: :order_drivers, dependent: :destroy
  has_one :beer_dispatch, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank
  before_validation :generate_order_number, on: :create
  def self.search(params, territory_id)

    query = where(
      status_id: [1, 2],
      territory_id: territory_id
    )

    # Search by order number
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "order_number LIKE ?",
        search
      )
    end

    # Start date filter
    if params[:start_date].present?
      query = query.where(
        "DATE(created_at) >= ?",
        params[:start_date]
      )
    end

    # End date filter
    if params[:end_date].present?
      query = query.where(
        "DATE(created_at) <= ?",
        params[:end_date]
      )
    end

    query
  end

  def self.search_vendor_purchases(params, territory_id)
    if params[:query].present?
      where("order_number LIKE ? AND status_id IN (?) AND territory_id = ?", "%#{sanitize_sql_like(params[:query])}%", [4], territory_id)
    else
      where(status_id: [4], territory_id: territory_id)
    end
  end

  def total_price
    order_items.sum(&:total)
  end

  private
  def generate_order_number
    if self.order_number.blank?
      last_order = Order.order(:created_at).last
      next_number = last_order&.order_number.to_i + 1 || 1
      self.order_number = next_number.to_s.rjust(5, '0')
    end
  end
end
