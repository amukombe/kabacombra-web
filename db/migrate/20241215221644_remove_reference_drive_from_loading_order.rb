class RemoveReferenceDriveFromLoadingOrder < ActiveRecord::Migration[7.2]
  def change
    remove_reference :loading_orders, :driver, null: false, foreign_key: true
  end
end
