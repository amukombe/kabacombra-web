class CreateUserStores < ActiveRecord::Migration[7.2]
  def change
    create_table :user_stores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_stores, [:user_id, :store_id], unique: true
  end
end