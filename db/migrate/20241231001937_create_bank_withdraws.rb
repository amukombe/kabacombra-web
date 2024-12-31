class CreateBankWithdraws < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_withdraws do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.date :withdraw_date
      t.decimal :amount
      t.string :withdraw_location
      t.string :reason
      t.string :withdrawn_by
      t.string :transaction_reference
      t.string :additional_info

      t.timestamps
    end
  end
end
