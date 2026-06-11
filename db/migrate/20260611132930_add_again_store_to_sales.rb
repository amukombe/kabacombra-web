class AddAgainStoreToSales < ActiveRecord::Migration[7.2]
  def change
    add_reference :sales, :store, null: true, foreign_key: true
  end
end
