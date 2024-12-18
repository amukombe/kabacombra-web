class AddStockNoToInventoryItem < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :stock_no, :string
  end
end
