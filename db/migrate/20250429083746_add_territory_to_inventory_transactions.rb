class AddTerritoryToInventoryTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventory_transactions, :territory, null: true, foreign_key: true
  end
end
