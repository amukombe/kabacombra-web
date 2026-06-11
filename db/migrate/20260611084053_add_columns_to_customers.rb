class AddColumnsToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :brn, :string
    add_column :customers, :tin, :string
  end
end
