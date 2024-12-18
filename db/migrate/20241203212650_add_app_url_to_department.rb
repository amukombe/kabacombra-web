class AddAppUrlToDepartment < ActiveRecord::Migration[7.2]
  def change
    add_column :departments, :app_url, :string
  end
end
