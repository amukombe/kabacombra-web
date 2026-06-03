class NileProduct < ApplicationRecord
  belongs_to :nile_category
  has_many :order_items, dependent: :destroy
  has_many :loading_order_items, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  belongs_to :empty_type, optional: true
  has_many :inventory_transactions, dependent: :destroy
  has_many :vendor_adjustiment_items, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  has_many :stock_transfer_items, dependent: :destroy
  has_many :store_transactions, dependent: :destroy
  has_many :beer_return_items, dependent: :destroy
  validates :name, uniqueness: true, presence: true
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  
end
