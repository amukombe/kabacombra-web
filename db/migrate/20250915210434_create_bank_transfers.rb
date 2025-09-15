class CreateBankTransfers < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_transfers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :from_account, null: false, foreign_key: {to_table: :bank_accounts}
      t.references :to_account, null: false, foreign_key: {to_table: :bank_accounts}
      t.datetime :transfer_date
      t.decimal :amount
      t.text :reason
      t.string :transfer_ref

      t.timestamps
    end
  end
end
