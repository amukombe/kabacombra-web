class AddSalesRouteToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :sales_route, :string
    add_column :sales, :customer, :string
    add_column :sales, :customer_mobile, :string
  end
end
