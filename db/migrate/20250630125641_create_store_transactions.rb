class CreateStoreTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :store_transactions do |t|
      t.references :nile_product, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :quantity
      t.string :direction
      t.string :movement_type
      t.string :notes

      t.timestamps
    end
  end
end
