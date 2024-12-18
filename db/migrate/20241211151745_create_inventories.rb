class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :total

      t.timestamps
    end
  end
end
