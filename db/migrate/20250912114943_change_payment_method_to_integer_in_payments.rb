class ChangePaymentMethodToIntegerInPayments < ActiveRecord::Migration[7.2]
  def change
    rename_column :payments, :payment_method, :integer
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
