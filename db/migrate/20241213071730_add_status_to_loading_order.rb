class AddStatusToLoadingOrder < ActiveRecord::Migration[7.2]
  def change
    add_reference :loading_orders, :status, null: false, foreign_key: true
  end
end
