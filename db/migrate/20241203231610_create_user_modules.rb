class CreateUserModules < ActiveRecord::Migration[7.2]
  def change
    create_table :user_modules do |t|
      t.references :system_module, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
