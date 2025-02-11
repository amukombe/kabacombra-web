class CreateSaleEmpties < ActiveRecord::Migration[7.2]
  def change
    create_table :sale_empties do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :empty_type, null: false, foreign_key: true
      t.integer :expected
      t.integer :received
      t.integer :variance

      t.timestamps
    end
  end
end
