class RemoveSaleTypeFromLoadingOrders < ActiveRecord::Migration[7.2]
  def change
    remove_reference :loading_orders, :sale_type, null: false, foreign_key: true
  end
end
