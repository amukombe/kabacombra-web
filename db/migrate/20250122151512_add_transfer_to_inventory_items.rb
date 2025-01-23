class AddTransferToInventoryItems < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :transfers, :decimal, default: 0.00
    add_column :inventory_items, :nbl_return, :decimal, default: 0.00
  end
end
