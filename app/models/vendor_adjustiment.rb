class VendorAdjustiment < ApplicationRecord
  belongs_to :user
  belongs_to :purchase_type
  belongs_to :territory
  has_many :vendor_adjustiment_items, dependent: :destroy
  accepts_nested_attributes_for :vendor_adjustiment_items, allow_destroy: true, reject_if: :all_blank
end
