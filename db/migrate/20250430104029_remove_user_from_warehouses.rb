class RemoveUserFromWarehouses < ActiveRecord::Migration[7.2]
  def change
    remove_reference :warehouses, :user, null: false, foreign_key: true
  end
end
