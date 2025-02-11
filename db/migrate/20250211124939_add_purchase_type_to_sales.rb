class AddPurchaseTypeToSales < ActiveRecord::Migration[7.2]
  def change
    add_reference :sales, :purchase_type, null: true, foreign_key: true
    remove_column :sales, :sale_type
  end
end
