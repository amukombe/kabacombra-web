class CreateLoadingOrderAllocations < ActiveRecord::Migration[7.2]
  def change
    create_table :loading_order_allocations do |t|
      t.references :loading_order, null: false, foreign_key: true
      t.references :loading_order_item, null: false, foreign_key: true
      t.references :inventory_item, null: false, foreign_key: true
      t.decimal :quantity, :precision => 15

      t.timestamps
    end
  end
end
