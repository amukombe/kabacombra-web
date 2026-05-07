class BeerReturn < ApplicationRecord
  belongs_to :loading_order
  has_many :beer_return_items, dependent: :destroy
  belongs_to :territory
  accepts_nested_attributes_for :beer_return_items, allow_destroy: true
  after_create :create_inventory_transactions
  def total_returned
    beer_return_items.sum(:quantity_returned) 
  end

  def self.search(params, territory_id)
    if params[:query].present?
      where("product_name LIKE ? AND territory_id = ?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
    else
      where(territory_id: territory_id)
    end
  end

  private 
  def create_inventory_transactions
    beer_return_items.each do |item|
      quantity = item.quantity_returned
      next unless quantity.present? && quantity > 0

      InventoryTransaction.create!(
        nile_product_id: item.nile_product_id,
        territory_id: self.territory_id,
        transaction_quantity: quantity,
        transaction_type: 'return',
        direction: 'in',
        transaction_date: self.return_date
      )
    end
  end
end
