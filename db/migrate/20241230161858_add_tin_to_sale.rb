class AddTinToSale < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :tin, :string
  end
end
