class UpdateVendorPayments < ActiveRecord::Migration[7.2]
  def change
    rename_column :vendor_payments,
                  :payments,
                  :amount

    rename_column :vendor_payments,
                  :suspence,
                  :suspense_amount

    add_column :vendor_payments,
               :payment_no,
               :string

    add_column :vendor_payments,
               :payment_method,
               :integer,
               default: 0

    add_column :vendor_payments,
               :notes,
               :text
  end
end