class CreateInventoryTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :inventory_transactions do |t|
      t.references :inventory_item, null: false, foreign_key: true
      t.datetime :transaction_date
      t.decimal :transaction_quantity
      t.string :transaction_type
      t.string :direction
      t.text :note

      t.timestamps
    end
  end
end
