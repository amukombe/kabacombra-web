class CreateSaleItemDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :sale_item_discounts do |t|
      t.references :sale_item, null: true, foreign_key: true
      t.references :discount, null: true, foreign_key: true
      t.string :discount_name
      t.string :discount_type
      t.decimal :discount_value
      t.decimal :discount_amount

      t.timestamps
    end
  end
end
