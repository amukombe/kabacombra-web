class Discount < ApplicationRecord
  scope :active, -> { where(active: true) }

  enum discount_type: {
    percentage: "percentage",
    fixed: "fixed"
  }

  enum rule_type: {
    simple: "simple",
    buy_x_discount_y: "buy_x_discount_y"
  }

  validates :name, presence: true
  validates :discount_type, presence: true
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :rule_type, presence: true

  def self.search(params)
    params[:query].blank? ? all : where("name LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
  end
end