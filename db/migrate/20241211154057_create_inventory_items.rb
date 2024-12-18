class CreateInventoryItems < ActiveRecord::Migration[7.2]
  def change
    create_table :inventory_items do |t|
      t.references :inventory, null: false, foreign_key: true
      t.references :nile_product, null: false, foreign_key: true
      t.decimal :quantity_ordered
      t.decimal :quantity_dispatched
      t.decimal :quantity_received
      t.decimal :quantity_sold
      t.decimal :purchase_price
      t.decimal :selling_price
      t.boolean :is_active, default: false
      t.boolean :is_closed, default: false
      t.boolean :is_deleted, default: false
      t.references :user, null: false, foreign_key: true
      t.date :manufacture_date
      t.date :expiry_date
      t.datetime :delivery_time

      t.timestamps
    end
  end
end
