class CreateCheques < ActiveRecord::Migration[7.2]
  def change
    create_table :cheques do |t|
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :bank_transaction, null: false, foreign_key: true
      t.string :cheque_number
      t.string :payee
      t.string :status
      t.date :issue_date
      t.date :cleared_date

      t.timestamps
    end
  end
end
