class AddInventoryTransactionsCreatedToStockTransfers < ActiveRecord::Migration[7.2]
  def change
    add_column :stock_transfers, :inventory_transactions_created, :boolean, default: false
  end
end
