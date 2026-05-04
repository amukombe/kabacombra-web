class AddColumnsToEmptyTypes < ActiveRecord::Migration[7.2]
  def change
    add_column :empty_types, :rcode, :string
    add_column :empty_types, :shell_type, :string
    add_column :empty_types, :scode, :string
    add_column :empty_types, :shell_price, :decimal
    add_column :empty_types, :bottle_type, :string
    add_column :empty_types, :bcode, :string
    add_column :empty_types, :shell_number, :integer
    add_column :empty_types, :crate_size, :integer
  end
end
