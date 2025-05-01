class AddWarehouseToInventory < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventories, :warehouse, null: true, foreign_key: true
  end
end
