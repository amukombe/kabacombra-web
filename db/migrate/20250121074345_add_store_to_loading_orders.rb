class AddStoreToLoadingOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :loading_orders, :store, null: true, foreign_key: true
  end
end
