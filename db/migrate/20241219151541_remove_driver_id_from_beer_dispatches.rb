class RemoveDriverIdFromBeerDispatches < ActiveRecord::Migration[7.2]
  def change
    remove_reference :beer_dispatches, :driver, null: false, foreign_key: true
    add_column :beer_dispatches, :driver_name, :string
    add_column :beer_dispatches, :driver_mobile, :string
  end
end
