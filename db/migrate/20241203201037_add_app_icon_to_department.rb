class AddAppIconToDepartment < ActiveRecord::Migration[7.2]
  def change
    add_column :departments, :app_icon, :string
  end
end
