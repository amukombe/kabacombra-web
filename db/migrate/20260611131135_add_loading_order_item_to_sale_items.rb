class AddLoadingOrderItemToSaleItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :sale_items, :loading_order_item, null: false, foreign_key: true
  end
end
