class AddBankAccountToPayments < ActiveRecord::Migration[7.2]
  def change
    add_reference :payments, :bank_account, null: false, foreign_key: true
  end
end
