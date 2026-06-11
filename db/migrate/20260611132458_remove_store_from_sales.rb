class RemoveStoreFromSales < ActiveRecord::Migration[7.2]
  def change
    remove_reference :sales, :store, null: false, foreign_key: true
  end
end
