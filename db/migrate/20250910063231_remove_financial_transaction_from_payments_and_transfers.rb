class RemoveFinancialTransactionFromPaymentsAndTransfers < ActiveRecord::Migration[7.2]
  def change
    remove_reference :payments, :financial_transaction, null: false, foreign_key: true
  end
end
