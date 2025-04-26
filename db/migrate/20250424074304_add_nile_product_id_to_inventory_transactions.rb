class AddNileProductIdToInventoryTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventory_transactions, :nile_product, null: false, foreign_key: true
  end
end
