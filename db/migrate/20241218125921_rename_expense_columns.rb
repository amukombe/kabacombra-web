class RenameExpenseColumns < ActiveRecord::Migration[7.2]
  def change
    rename_column :expenses, :expese_date, :expense_date
    remove_column :expenses, :reason
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
