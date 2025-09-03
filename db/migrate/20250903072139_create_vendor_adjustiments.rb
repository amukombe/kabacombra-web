class CreateVendorAdjustiments < ActiveRecord::Migration[7.2]
  def change
    create_table :vendor_adjustiments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :purchase_type, null: false, foreign_key: true
      t.date :adjustment_date
      t.references :territory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
