class AddStoreToStoreTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :store_transactions, :store, null: false, foreign_key: true
  end
end
