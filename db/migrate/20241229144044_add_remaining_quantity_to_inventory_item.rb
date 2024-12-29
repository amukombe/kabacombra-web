class AddRemainingQuantityToInventoryItem < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :remaining_quantity, :decimal
  end
end
