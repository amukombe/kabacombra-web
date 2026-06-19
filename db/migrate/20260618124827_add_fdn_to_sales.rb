class AddFdnToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :Fdn, :string
    add_column :sales, :InvoiceNo, :string
  end
end
