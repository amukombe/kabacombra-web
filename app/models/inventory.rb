class Inventory < ApplicationRecord
  belongs_to :beer_dispatch, optional: true
  has_many :inventory_items, dependent: :destroy
  belongs_to :user
  belongs_to :warehouse
  accepts_nested_attributes_for :inventory_items, allow_destroy: true, reject_if: :all_blank
  
  def self.search(params, territory_id)
    if params[:query].present?
      joins(:beer_dispatch).where("fdn_number LIKE ? AND territory_id = ? AND beer_dispatches.status_id IN (?)", "%#{sanitize_sql_like(params[:query])}%", territory_id, [13])
    else
      joins(:beer_dispatch).where(territory_id: territory_id, beer_dispatches: { status_id: [13] })
    end
  end

  def self.search_received(params, territory_id)
    if params[:query].present?
      joins(:beer_dispatch).where("fdn_number LIKE ? AND territory_id = ? AND beer_dispatches.status_id IN (?)", "%#{sanitize_sql_like(params[:query])}%", territory_id, [4,13])
    else
      joins(:beer_dispatch).where(territory_id: territory_id, beer_dispatches: { status_id: [4,13] })
    end
  end

  def total_price
    inventory_items.sum(&:total)
  end
  def total_case
    inventory_items.sum(&:total_case)
  end
  def total_Purchase
    total_price + total_case
  end
end
