class MakePositionNotNullOnEmployees < ActiveRecord::Migration[7.2]
  def change
    change_column_null :employees, :position_id, false
  end
end
