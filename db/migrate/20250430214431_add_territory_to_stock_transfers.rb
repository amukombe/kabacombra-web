class AddTerritoryToStockTransfers < ActiveRecord::Migration[7.2]
  def change
    add_reference :stock_transfers, :territory, null: false, foreign_key: true
  end
end
