class CreateRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :routes do |t|
      t.string :name
      t.string :start_location
      t.string :end_location
      t.decimal :distatnce

      t.timestamps
    end
  end
end
