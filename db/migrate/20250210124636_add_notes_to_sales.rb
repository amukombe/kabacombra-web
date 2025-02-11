class AddNotesToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :notes, :text
    remove_column :sales, :customer
  end
end
