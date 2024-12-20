class AddEmptyPrcieToNileProduct < ActiveRecord::Migration[7.2]
  def change
    add_column :nile_products, :epmty_price, :decimal
  end
end
