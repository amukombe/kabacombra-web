class CreateBankReconciliationItems < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_reconciliation_items do |t|
      t.references :bank_reconciliation, null: false, foreign_key: true
      t.references :bank_transaction, null: false, foreign_key: true
      t.date :bank_date
      t.string :bank_reference
      t.string :description
      t.decimal :bank_amount
      t.boolean :matched
      t.boolean :cleared
      t.text :notes

      t.timestamps
    end
  end
end
