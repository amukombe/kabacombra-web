class RemoveNileProductFromDestinations < ActiveRecord::Migration[7.2]
  def change
    remove_reference :destinations, :nile_product, null: false, foreign_key: true
    remove_column :destinations, :selling_price, :decimal
  end
end
