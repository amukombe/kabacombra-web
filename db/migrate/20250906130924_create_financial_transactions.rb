class CreateFinancialTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :financial_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :amount
      t.date :transaction_date
      t.string :reference
      t.string :status

      t.timestamps
    end
  end
end
