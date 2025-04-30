class NileProduct < ApplicationRecord
  belongs_to :nile_category
  has_many :order_items
  has_many :loading_order_items
  has_many :sale_items, through: :loading_order_items
  has_many :inventory_items
  belongs_to :empty_type, optional: true
  has_many :inventory_transactions
  validates :name, uniqueness: true, presence: true
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  
end
