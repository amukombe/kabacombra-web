class CreateDispatchItems < ActiveRecord::Migration[7.2]
  def change
    create_table :dispatch_items do |t|
      t.references :nile_product, null: false, foreign_key: true
      t.string :beer_dispatch
      t.decimal :quantity_dispatched

      t.timestamps
    end
  end
end
