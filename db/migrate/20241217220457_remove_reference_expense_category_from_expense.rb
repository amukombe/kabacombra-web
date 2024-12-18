class RemoveReferenceExpenseCategoryFromExpense < ActiveRecord::Migration[7.2]
  def change
    remove_reference :expenses, :expense_category, null: false, foreign_key: true
  end
end
