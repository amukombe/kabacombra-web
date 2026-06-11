class AddCustomerToSales < ActiveRecord::Migration[7.2]
  def change
    add_reference :sales, :customer, null: true, foreign_key: true
  end
end
