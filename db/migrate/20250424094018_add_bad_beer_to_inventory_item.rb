class AddBadBeerToInventoryItem < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :bad_beer, :decimal
  end
end
