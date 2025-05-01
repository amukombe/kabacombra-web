class RemoveFromStockTransfers < ActiveRecord::Migration[7.2]
  def change
    remove_column :stock_transfers, :source_type
    remove_column :stock_transfers, :destination_type
  end
end
