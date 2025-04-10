class RemoveBeerDispatchIdFromInventories < ActiveRecord::Migration[7.2]
  def change
    remove_reference :inventories, :beer_dispatch, null: false, foreign_key: true
  end
end
