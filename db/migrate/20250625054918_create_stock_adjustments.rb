class CreateStockAdjustments < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_adjustments do |t|
      t.references :nile_product, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :quantity
      t.string :direction # in or out
      t.string :movement_type # purchase, sale,
      t.string :notes
      t.integer :source_id # this is the id of where it's coming from

      t.timestamps
    end
  end
end
