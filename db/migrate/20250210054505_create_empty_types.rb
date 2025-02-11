class CreateEmptyTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :empty_types do |t|
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end
