class AddMissingBottlesToInventoryItem < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :missing_bottles, :decimal
    add_column :inventory_items, :complaints, :decimal
  end
end
