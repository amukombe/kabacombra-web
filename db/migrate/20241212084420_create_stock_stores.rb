class CreateStockStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_stores do |t|
      t.references :inventory_item, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
