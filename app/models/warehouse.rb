class Warehouse < ApplicationRecord
  belongs_to :territory

  def self.search(params)
    params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
