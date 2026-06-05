class Destination < ApplicationRecord
  belongs_to :nile_product
  validates :name, uniqueness: true, presence: true
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
