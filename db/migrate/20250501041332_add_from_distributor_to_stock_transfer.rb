class AddFromDistributorToStockTransfer < ActiveRecord::Migration[7.2]
  def change
    add_column :stock_transfers, :from_distributor, :string
    add_column :stock_transfers, :to_distributor, :string
  end
end
