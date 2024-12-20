class AddReceiptNoToSale < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :receipt_no, :string
  end
end
