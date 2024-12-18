class TruckType < ApplicationRecord
    validates :name, uniqueness: true, presence: true
    has_many :trucks
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end
end
