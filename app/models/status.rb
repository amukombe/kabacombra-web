class Status < ApplicationRecord
    validates :name, presence: true
    validates :code, presence: true, uniqueness:true
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end
end
