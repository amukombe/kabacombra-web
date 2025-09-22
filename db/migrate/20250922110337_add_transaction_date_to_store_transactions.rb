class AddTransactionDateToStoreTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :store_transactions, :transaction_date, :datetime
  end
end
