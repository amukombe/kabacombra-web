class CreateBankReconciliations < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_reconciliations do |t|
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :bank_account, null: false, foreign_key: true
      t.date :statement_from
      t.date :statement_to
      t.decimal :book_balance
      t.decimal :bank_balance
      t.decimal :difference
      t.string :status
      t.string :reference
      t.datetime :reconciled_at

      t.timestamps
    end
  end
end
