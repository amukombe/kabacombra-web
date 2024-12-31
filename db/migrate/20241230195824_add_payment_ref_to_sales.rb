class AddPaymentRefToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :payment_ref, :string
  end
end
