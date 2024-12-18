class CreateDrivers < ActiveRecord::Migration[7.2]
  def change
    create_table :drivers do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :license_number
      t.date :issued_date
      t.date :expiry_date
      t.string :license_class
      t.string :issued_by

      t.timestamps
    end
  end
end
