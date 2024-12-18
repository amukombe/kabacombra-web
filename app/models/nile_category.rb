class NileCategory < ApplicationRecord
    has_many :products
    validates :name, uniqueness: true, presence: true
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end
end
