class AddCustomerToSale < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :customer_name, :string
  end
end
