class CreateSales < ActiveRecord::Migration[7.2]
  def change
    create_table :sales do |t|
      t.references :loading_order_item, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :quantity_sold
      t.decimal :amount
      t.decimal :total
      t.string :sale_type
      t.string :mode_of_payment

      t.timestamps
    end
  end
end
