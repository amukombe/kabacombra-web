class CreateTruckDrivers < ActiveRecord::Migration[7.2]
  def change
    create_table :truck_drivers do |t|
      t.references :truck, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.string :date_assigned
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
