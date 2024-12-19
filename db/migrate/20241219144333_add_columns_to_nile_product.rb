class AddColumnsToNileProduct < ActiveRecord::Migration[7.2]
  def change
    add_column :nile_products, :buying_price, :string
    add_column :nile_products, :selling_price, :string
    add_column :nile_products, :empty_type, :string
  end
end
