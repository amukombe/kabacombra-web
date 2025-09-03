class CreateVendorAdjustimentItems < ActiveRecord::Migration[7.2]
  def change
    create_table :vendor_adjustiment_items do |t|
      t.references :vendor_adjustiment, null: false, foreign_key: true
      t.references :nile_product, null: false, foreign_key: true
      t.decimal :quantity
      t.decimal :quantity_sold

      t.timestamps
    end
  end
end
