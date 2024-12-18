class CreateEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :email
      t.string :mobile
      t.date :dob
      t.string :position
      t.string :address
      t.string :nssf
      t.string :tin

      t.timestamps
    end
  end
end
