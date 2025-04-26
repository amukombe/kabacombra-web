class InventoryTransaction < ApplicationRecord
  belongs_to :inventory_item

  def self.search_openning_stock(params, territory_id, product_id)
    query = joins(inventory_item:[:inventory, :nile_product])
    .where("inventories.territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "in")

    if params[:query].present?
      query = joins(inventory_item:[:inventory, :nile_product])
      .where("inventories.territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "in")
    end
    query
  end
end
