class AddReturnsToInventoryItems < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :returns, :decimal, default: 0.00
  end
end
