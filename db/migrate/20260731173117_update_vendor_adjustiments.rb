class UpdateVendorAdjustiments < ActiveRecord::Migration[7.2]
  def change
    add_column :vendor_adjustiments,
               :amount,
               :decimal,
               precision: 15,
               scale: 2,
               default: 0,
               null: false

    add_column :vendor_adjustiments,
               :adjustment_type,
               :string,
               default: "credit"

    add_column :vendor_adjustiments,
               :adjustment_category,
               :string,
               default: "manual"

    add_column :vendor_adjustiments,
               :calculation_base_amount,
               :decimal,
               precision: 15,
               scale: 2,
               default: 0

    add_column :vendor_adjustiments,
               :calculation_rate,
               :decimal,
               precision: 6,
               scale: 4,
               default: 0

    add_column :vendor_adjustiments,
               :source_type,
               :string

    add_column :vendor_adjustiments,
               :source_id,
               :bigint

    add_column :vendor_adjustiments,
               :description,
               :text
  end
end