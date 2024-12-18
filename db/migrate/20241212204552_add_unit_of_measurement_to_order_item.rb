class AddUnitOfMeasurementToOrderItem < ActiveRecord::Migration[7.2]
  def change
    add_reference :order_items, :unit_of_measurement, null: false, foreign_key: true
  end
end
