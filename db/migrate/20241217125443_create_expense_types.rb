class CreateExpenseTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :expense_types do |t|
      t.references :expense_category, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
