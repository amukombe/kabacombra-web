class AddNileProductToSaleItems < ActiveRecord::Migration[7.2]
  def change
    remove_reference :sale_items, :loading_order_item, null: false, foreign_key: true
    add_reference :sale_items, :nile_product, null: false, foreign_key: true
  end
end
