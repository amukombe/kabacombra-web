class Inventory < ApplicationRecord
  belongs_to :beer_dispatch, optional: true
  has_many :inventory_items, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :inventory_items, allow_destroy: true, reject_if: :all_blank
  
end
