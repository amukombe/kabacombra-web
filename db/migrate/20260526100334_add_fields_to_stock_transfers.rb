class AddFieldsToStockTransfers < ActiveRecord::Migration[7.2]
  def change
    add_column :stock_transfers, :numberplate, :string
    add_column :stock_transfers, :driver_details, :string
    add_reference :stock_transfers, :user, null: true, foreign_key: true
  end
end
