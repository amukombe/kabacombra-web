class CreateStockTransfers < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_transfers do |t|
      t.string :transfer_type
      t.string :source_type
      t.integer :source_id
      t.string :destination_type
      t.integer :destination_id
      t.date :transfer_date
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
