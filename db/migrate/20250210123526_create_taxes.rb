class CreateTaxes < ActiveRecord::Migration[7.2]
  def change
    create_table :taxes do |t|
      t.string :name
      t.decimal :tax_percentage

      t.timestamps
    end
  end
end
