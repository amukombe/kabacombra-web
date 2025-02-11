class EmptyType < ApplicationRecord
    has_one :nile_product
    has_many :sale_empties
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end
end
