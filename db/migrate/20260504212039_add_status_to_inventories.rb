class AddStatusToInventories < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventories, :status, null: true, foreign_key: true
  end
end
