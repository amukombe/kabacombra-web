class AddReferenceStoreToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :store, null: true, foreign_key: true
  end
end
