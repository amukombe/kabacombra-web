class AddIconToDepartment < ActiveRecord::Migration[7.2]
  def change
    add_column :departments, :icon, :string
  end
end
