class AddPositionToEmployee < ActiveRecord::Migration[7.2]
  def change
    add_reference :employees, :position, null: true, foreign_key: true
    # Set a default position_id for existing employees
    reversible do |dir|
      dir.up do
        # Add a default position_id for all existing records (replace 1 with your desired default ID)
        Employee.update_all(position_id: 1)
      end
    end

    # Change the column to NOT NULL after populating it
    change_column_null :employees, :position_id, false
  end
end
