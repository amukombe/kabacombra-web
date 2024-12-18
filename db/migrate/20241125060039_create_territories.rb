class CreateTerritories < ActiveRecord::Migration[7.2]
  def change
    create_table :territories do |t|
      t.string :name
      t.string :address
      t.string :telephone
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
