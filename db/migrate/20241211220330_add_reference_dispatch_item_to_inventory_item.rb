class AddReferenceDispatchItemToInventoryItem < ActiveRecord::Migration[7.2]
  def change
    remove_reference :inventory_items, :nile_product, index:true, foreign_key: true
    add_reference :inventory_items, :dispatch_item, null: false, foreign_key: true
  end
end
