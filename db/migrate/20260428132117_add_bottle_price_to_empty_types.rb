class AddBottlePriceToEmptyTypes < ActiveRecord::Migration[7.2]
  def change
    add_column :empty_types, :bottle_price, :decimal
  end
end
