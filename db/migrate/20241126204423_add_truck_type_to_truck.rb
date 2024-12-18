class AddTruckTypeToTruck < ActiveRecord::Migration[7.2]
  def change
    add_reference :trucks, :truck_type, null: false, foreign_key: true
  end
end
