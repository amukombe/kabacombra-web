class Store < ApplicationRecord
  belongs_to :territory
  has_many :inventory_item_stores
  has_many :inventory_items, through: :inventory_item_stores
  validates :name, :territory_id, presence: true
  def self.search(params)
    params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  def store_name
    "#{name} - #{territory.name}"
  end
end
