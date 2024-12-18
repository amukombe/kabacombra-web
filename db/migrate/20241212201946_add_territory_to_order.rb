class AddTerritoryToOrder < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :territory, null: false, foreign_key: true
    add_reference :beer_dispatches, :territory, null: false, foreign_key: true
    add_reference :inventories, :territory, null: false, foreign_key: true
  end
end
