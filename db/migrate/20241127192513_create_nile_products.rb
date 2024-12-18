class CreateNileProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :nile_products do |t|
      t.string :name
      t.integer :crate_size
      t.string :bottle_size
      t.string :description
      t.references :nile_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
