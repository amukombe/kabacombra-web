class AddTerritoryToBeerReturns < ActiveRecord::Migration[7.2]
  def change
    add_reference :beer_returns, :territory, null: false, foreign_key: true
  end
end
