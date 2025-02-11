class RemoveEmptiesReturnedSales < ActiveRecord::Migration[7.2]
  def change
    remove_column :sales, :empties_returned
    remove_column :sales, :cash_for_empties
  end
end
