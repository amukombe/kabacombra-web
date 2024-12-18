class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.references :expense_type, null: false, foreign_key: true
      t.references :expense_category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.string :expense_title
      t.integer :received_by
      t.integer :authorized_by
      t.string :reason
      t.string :description
      t.date :expese_date
      t.decimal :amount
      t.string :source_of_income

      t.timestamps
    end
  end
end
