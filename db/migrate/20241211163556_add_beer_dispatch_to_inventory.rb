class AddBeerDispatchToInventory < ActiveRecord::Migration[7.2]
  def change
    remove_reference :inventories, :order, index:true, foreign_key: true
    add_reference :inventories, :beer_dispatch, null: false, foreign_key: true
  end
end
