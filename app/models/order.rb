class Order < ApplicationRecord
  belongs_to :user
  belongs_to :status
  has_many :order_items, dependent: :destroy
  has_many :order_drivers
  has_many :drivers, through: :order_drivers
  has_one :beer_dispatch
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank
  before_validation :generate_order_number, on: :create
  def self.search(params, territory_id)
    if params[:query].present?
      where("order_number LIKE ? AND status_id IN (?) AND territory_id = ?", "%#{sanitize_sql_like(params[:query])}%", [1,2], territory_id)
    else
      where(status_id: [1,2], territory_id: territory_id)
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
