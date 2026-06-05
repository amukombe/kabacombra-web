class CreateDestinations < ActiveRecord::Migration[7.2]
  def change
    create_table :destinations do |t|
      t.references :nile_product, null: false, foreign_key: true
      t.decimal :selling_price
      t.string :name

      t.timestamps
    end
  end
end
