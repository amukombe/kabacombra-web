class AddNileProductToInventoryItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventory_items, :nile_product, null: true, foreign_key: true
  end
end
