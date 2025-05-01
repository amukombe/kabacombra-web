class CreateStockTransferItems < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_transfer_items do |t|
      t.references :nile_product, null: false, foreign_key: true
      t.references :stock_transfer, null: false, foreign_key: true
      t.decimal :transfer_quantity

      t.timestamps
    end
  end
end
