class AddStoreToSales < ActiveRecord::Migration[7.2]
  def change
    add_reference :sales, :store, null: false, foreign_key: true
  end
end
