class AddEmptyTypeToNileProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :nile_products, :empty_type
    add_reference :nile_products, :empty_type, null: true, foreign_key: true
    remove_column :nile_products, :empty_price
    remove_column :nile_products, :empty_price
  end
end
