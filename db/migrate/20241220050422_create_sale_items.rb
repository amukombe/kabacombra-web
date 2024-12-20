class CreateSaleItems < ActiveRecord::Migration[7.2]
  def change
    create_table :sale_items do |t|
      t.references :loading_order_item, null: false, foreign_key: true
      t.decimal :quantity_sold
      t.decimal :amount
      t.decimal :total

      t.timestamps
    end
  end
end
