class AddReceivedDateToBeerDispatch < ActiveRecord::Migration[7.2]
  def change
    add_column :beer_dispatches, :received_date, :datetime, null: true
  end
end
