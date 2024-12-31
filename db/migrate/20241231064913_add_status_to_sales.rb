class AddStatusToSales < ActiveRecord::Migration[7.2]
  def change
    add_reference :sales, :status, null: false, foreign_key: true
  end
end
