class AddTransactionTypeToBankTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :bank_transactions, :transaction_type, :string
  end
end
