class AddDepartureDateToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :departure_date, :date
  end
end
