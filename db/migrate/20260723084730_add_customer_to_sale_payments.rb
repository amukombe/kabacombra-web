class AddCustomerToSalePayments < ActiveRecord::Migration[7.2]
  def up
    add_reference :sale_payments,
                  :customer,
                  null: true,
                  foreign_key: true

    execute <<~SQL
      UPDATE sale_payments
      INNER JOIN sales
        ON sales.id = sale_payments.sale_id
      SET sale_payments.customer_id = sales.customer_id
      WHERE sale_payments.customer_id IS NULL
    SQL

    change_column_null :sale_payments, :customer_id, false

    # A payment may later have its amount shared with other invoices.
    # Keep sale_id for the original invoice where payment was received,
    # but allow it to be optional for future flexibility.
    change_column_null :sale_payments, :sale_id, true
  end

  def down
    change_column_null :sale_payments, :sale_id, false

    remove_reference :sale_payments,
                     :customer,
                     foreign_key: true
  end
end