class RemovePositionFromEmployees < ActiveRecord::Migration[7.2]
  def change
    remove_column :employees, :position, :string
  end
end
