class AddNileProductToLoadinOrderItem < ActiveRecord::Migration[7.2]
  def change
    remove_reference :loading_order_items, :inventory_item
    add_reference :loading_order_items, :nile_product, null: false, foreign_key: true
  end
end
