class AddJournalNoAndRefNoToVendorAdjustiments < ActiveRecord::Migration[7.2]
  def change
    add_column :vendor_adjustiments, :journal_no, :string
    add_column :vendor_adjustiments, :ref_no, :string
  end
end
