class CreateBankAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_accounts do |t|
      t.references :bank, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :account_name
      t.string :account_number
      t.string :branch_name
      t.string :branch_code
      t.string :swiftcode

      t.timestamps
    end
  end
end
