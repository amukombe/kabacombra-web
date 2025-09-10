class CreateBankTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :financial_transaction, null: false, foreign_key: true
      t.references :bank_account, null: false, foreign_key: true
      t.string :method
      t.string :cheque_number
      t.decimal :amount
      t.date :cleared_date

      t.timestamps
    end
  end
end
