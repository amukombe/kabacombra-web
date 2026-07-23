class UpdateExistingOrderNumbers < ActiveRecord::Migration[7.0]
  def up
    Order.reset_column_information

    # Group orders by Year and Month of creation
    Order
      .order(:created_at, :id)
      .group_by { |order| order.created_at.strftime("%y%m") }
      .each do |prefix, orders|

      orders.each_with_index do |order, index|
        order.update_columns(
          order_number: "#{prefix}#{(index + 1).to_s.rjust(4, '0')}"
        )
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end