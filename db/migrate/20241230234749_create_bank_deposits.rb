class CreateBankDeposits < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_deposits do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.date :deposit_date
      t.decimal :amount
      t.string :deposit_location
      t.string :source_of_income
      t.string :deposited_by
      t.string :transaction_reference
      t.string :additional_info

      t.timestamps
    end
  end
end
