class AddReceivingFieldsToStockTransferItems < ActiveRecord::Migration[7.2]
  def change
    add_column :stock_transfer_items, :quantity_received, :decimal
    add_column :stock_transfer_items, :breakages, :decimal
    add_column :stock_transfer_items, :complaints, :decimal
  end
end
