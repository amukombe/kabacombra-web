class CreateBeerDispatches < ActiveRecord::Migration[7.2]
  def change
    create_table :beer_dispatches do |t|
      t.string :fdn_number
      t.string :truck_numberplate
      t.string :trailer_plate
      t.string :second_trailer
      t.string :delivery_plant
      t.string :shipping_point
      t.datetime :loading_time
      t.references :driver, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :dispatch_no
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
