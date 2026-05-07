class CreateBeerReturnItems < ActiveRecord::Migration[7.2]
  def change
    create_table :beer_return_items do |t|
      t.references :beer_return, null: false, foreign_key: true
      t.references :nile_product, null: false, foreign_key: true
      t.decimal :quantity_loaded
      t.decimal :quantity_returned
      t.decimal :holding_sale_quantity
      t.decimal :missing_bottles

      t.timestamps
    end
  end
end
