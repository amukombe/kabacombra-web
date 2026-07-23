class AddQuantityOrderedToSaleItems < ActiveRecord::Migration[7.2]
  def up
    add_column :sale_items,
               :quantity_ordered,
               :decimal,
               precision: 15,
               scale: 3,
               null: true

    # Existing sales assumed ordered quantity equals delivered quantity.
    execute <<~SQL
      UPDATE sale_items
      SET quantity_ordered = quantity_sold
      WHERE quantity_ordered IS NULL
    SQL

    change_column_null :sale_items,
                       :quantity_ordered,
                       false
  end

  def down
    remove_column :sale_items,
                  :quantity_ordered
  end
end