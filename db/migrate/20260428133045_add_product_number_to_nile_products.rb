class AddProductNumberToNileProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :nile_products, :product_number, :integer
  end
end
