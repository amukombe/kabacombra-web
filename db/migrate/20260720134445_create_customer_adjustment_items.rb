class CreateCustomerAdjustmentItems < ActiveRecord::Migration[7.2]
  def change
    create_table :customer_adjustment_items do |t|
      t.references :customer_adjustment, null: false, foreign_key: true
      t.references :sale_item, null: false, foreign_key: true
      t.references :nile_product, null: false, foreign_key: true
      t.decimal :quantity
      t.decimal :unit_price
      t.decimal :discount_amount
      t.decimal :tax_amount
      t.decimal :total_amount
      t.boolean :affects_stock
      t.text :reason

      t.timestamps
    end
  end
end
