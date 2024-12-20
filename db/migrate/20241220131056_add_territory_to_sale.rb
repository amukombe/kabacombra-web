class AddTerritoryToSale < ActiveRecord::Migration[7.2]
  def change
    add_reference :sales, :territory, null: false, foreign_key: true
    add_column :sales, :verified_by, :integer
  end
end
