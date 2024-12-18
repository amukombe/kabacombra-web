class CreateDepartmentModules < ActiveRecord::Migration[7.2]
  def change
    create_table :department_modules do |t|
      t.string :name
      t.string :module_url
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
