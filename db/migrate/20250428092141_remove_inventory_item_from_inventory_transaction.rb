class RemoveInventoryItemFromInventoryTransaction < ActiveRecord::Migration[7.2]
  def change
    remove_reference :inventory_transactions, :inventory_item, null: false, foreign_key: true
  end
end
