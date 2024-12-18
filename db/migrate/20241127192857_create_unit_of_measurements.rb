class CreateUnitOfMeasurements < ActiveRecord::Migration[7.2]
  def change
    create_table :unit_of_measurements do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
