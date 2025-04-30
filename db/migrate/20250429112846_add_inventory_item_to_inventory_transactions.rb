class AddInventoryItemToInventoryTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventory_transactions, :inventory_item, null: true, foreign_key: true
  end
end
