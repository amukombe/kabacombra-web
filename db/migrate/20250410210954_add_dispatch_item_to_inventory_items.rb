class AddDispatchItemToInventoryItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventory_items, :dispatch_item, foreign_key: true, null: true
  end
end
