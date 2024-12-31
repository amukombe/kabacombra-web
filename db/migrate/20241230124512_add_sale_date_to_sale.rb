class AddSaleDateToSale < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :sale_date, :datetime
  end
end
