class ChangeRecepientTypeToIntegerInPayments < ActiveRecord::Migration[7.2]
  def change
    change_column :payments, :recepient_type, :integer
  end
end
