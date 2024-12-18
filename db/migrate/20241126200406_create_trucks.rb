class CreateTrucks < ActiveRecord::Migration[7.2]
  def change
    create_table :trucks do |t|
      t.string :plate_number
      t.string :model
      t.string :chasis
      t.string :status
      t.references :car_make, null: false, foreign_key: true

      t.timestamps
    end
  end
end
