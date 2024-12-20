class RemoveColumnsFromSale < ActiveRecord::Migration[7.2]
  def change
    remove_column :sales, :quantity_sold, :decimal
    remove_reference :sales, :loading_order_item, null: false, foreign_key: true
    remove_column :sales, :amount, :decimal
    remove_column :sales, :total, :decimal
  end
end
