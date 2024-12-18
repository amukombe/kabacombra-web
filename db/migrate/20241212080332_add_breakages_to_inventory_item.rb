class AddBreakagesToInventoryItem < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :breakages, :decimal
  end
end
