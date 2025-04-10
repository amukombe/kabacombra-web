class AddBeerDispatchToInventory < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventories, :beer_dispatch, foreign_key: true, null: true
  end
end
