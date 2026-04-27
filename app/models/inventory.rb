class Inventory < ApplicationRecord
  belongs_to :beer_dispatch, optional: true
  has_many :inventory_items, dependent: :destroy
  belongs_to :user
  belongs_to :warehouse
  accepts_nested_attributes_for :inventory_items, allow_destroy: true, reject_if: :all_blank
  
  def self.search(params, territory_id)
    if params[:query].present?
      joins(:beer_dispatch).where("fdn_number LIKE ? AND territory_id = ?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
    else
      joins(:beer_dispatch).where(territory_id: territory_id)
    end
  end

  def total_price
    inventory_items.sum(&:total)
  end
  def total_case_value
    inventory_items.sum(&:total_case)
  end
  def total_Purchase
    total_price + total_case_value
  end
end
