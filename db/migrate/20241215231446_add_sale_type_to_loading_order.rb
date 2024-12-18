class AddSaleTypeToLoadingOrder < ActiveRecord::Migration[7.2]
  def change
    add_reference :loading_orders, :sale_type, null: false, foreign_key: true
  end
end
