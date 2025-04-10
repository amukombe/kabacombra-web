class RemoveDispatchItemFromInventoryItems < ActiveRecord::Migration[7.2]
  def change
    remove_reference :inventory_items, :dispatch_item, null: false, foreign_key: true
  end
end
