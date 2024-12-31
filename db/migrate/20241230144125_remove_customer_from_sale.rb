class RemoveCustomerFromSale < ActiveRecord::Migration[7.2]
  def change
    remove_reference :sales, :customer, null: false, foreign_key: true
  end
end
