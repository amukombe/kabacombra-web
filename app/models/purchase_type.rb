class PurchaseType < ApplicationRecord
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end

    has_many :sale_items
    has_many :vendor_adjustiments
end
