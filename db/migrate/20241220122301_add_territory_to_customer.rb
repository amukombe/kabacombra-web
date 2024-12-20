class AddTerritoryToCustomer < ActiveRecord::Migration[7.2]
  def change
    add_reference :customers, :territory, null: false, foreign_key: true
  end
end
