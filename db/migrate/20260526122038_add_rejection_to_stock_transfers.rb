class AddRejectionToStockTransfers < ActiveRecord::Migration[7.2]
  def change
    add_column :stock_transfers, :rejection_reason, :text
    add_column :stock_transfers, :received_by, :bigint
    add_column :stock_transfers, :received_at, :datetime
  end
end
