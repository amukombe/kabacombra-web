class RemovePurchaseTypeFromSales < ActiveRecord::Migration[7.2]
  def change
    remove_reference :sales, :purchase_type, null: false, foreign_key: true
  end
end
