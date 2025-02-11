class NileProduct < ApplicationRecord
  belongs_to :nile_category
  has_many :order_items
  has_many :loadding_order_items
  belongs_to :empty_type, optional: true
  validates :name, uniqueness: true, presence: true
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  
end
