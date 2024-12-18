class CreateEmployeeTerritories < ActiveRecord::Migration[7.2]
  def change
    create_table :employee_territories do |t|
      t.references :territory, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
