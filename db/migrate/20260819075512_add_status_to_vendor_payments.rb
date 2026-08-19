class AddStatusToVendorPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :vendor_payments, :status, :integer, default: 0
  end
end
