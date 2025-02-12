class AddReferenceOrderItemToDispatchItem < ActiveRecord::Migration[7.2]
  def change
    remove_reference :dispatch_items, :nile_product, index:true, foreign_key: true
    add_reference :dispatch_items, :order_item, null: false, foreign_key: true
  end
end
