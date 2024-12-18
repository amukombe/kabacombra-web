class Truck < ApplicationRecord
  belongs_to :car_make
  belongs_to :truck_type
  has_many :truck_drivers
  has_many :drivers, through: :truck_drivers
  def self.search(params)
    params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
