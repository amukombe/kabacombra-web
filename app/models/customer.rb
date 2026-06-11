class Customer < ApplicationRecord
    belongs_to :territory
    has_many :sales, dependent: :destroy

    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end
end
