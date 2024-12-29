class ChangeInventoryItemColumns < ActiveRecord::Migration[7.2]
  def change
    change_column_default :inventory_items, :remaining_quantity, 0
    change_column_default :inventory_items, :quantity_sold, 0
  end
end
