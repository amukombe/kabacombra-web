class AddEmptiesToSaleItem < ActiveRecord::Migration[7.2]
  def change
    add_column :sale_items, :empties_returned, :integer
    add_column :sale_items, :cash_for_empties, :decimal
  end
end
