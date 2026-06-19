class RemoveFdnFromSales < ActiveRecord::Migration[7.2]
  def change
    remove_column :sales, :Fdn, :string
    remove_column :sales, :InvoiceNo, :string
  end
end
