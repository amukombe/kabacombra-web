class Destination < ApplicationRecord
  has_many :nile_products, dependent: :nullify
  validates :name, uniqueness: true, presence: true
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
