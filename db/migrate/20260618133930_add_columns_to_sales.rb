class AddColumnsToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :fdn, :string
    add_column :sales, :invoice_no, :string
  end
end
