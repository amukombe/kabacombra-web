class AddGoodBeerToInventoryItems < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :good_beer, :decimal
  end
end
