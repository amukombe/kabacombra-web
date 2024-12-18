class CreateLoadingOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :loading_order_items do |t|
      t.references :loading_order, null: false, foreign_key: true
      t.references :inventory_item, null: false, foreign_key: true
      t.decimal :quantity_loaded

      t.timestamps
    end
  end
end
