class AddDestinationToNileProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :nile_products, :destination, null: true, foreign_key: true
  end
end
