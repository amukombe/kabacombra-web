class CreateBankImportMappings < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_import_mappings do |t|
      t.references :bank, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :date_column
      t.string :reference_column
      t.string :description_column
      t.string :debit_column
      t.string :credit_column
      t.string :balance_column

      t.timestamps
    end
  end
end
