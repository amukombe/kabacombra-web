class AddReferenceUserToInventory < ActiveRecord::Migration[7.2]
  def change
    remove_reference :inventory_items, :user, index:true, foreign_key: true
    remove_column :inventory_items, :delivery_time
    add_reference :inventories, :user, null: false, foreign_key: true
    add_column :inventories, :delivery_time, :datetime
  end
end
