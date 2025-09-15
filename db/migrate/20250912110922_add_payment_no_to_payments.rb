class AddPaymentNoToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :payment_no, :string
  end
end
