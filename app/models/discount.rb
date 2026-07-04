class Discount < ApplicationRecord
    scope :active, -> { where(active: true) }
    enum discount_type: { percentage: "percentage", fixed: "fixed" }
    validates :name, presence: true
    validates :discount_type, presence: true
    validates :discount_value, presence: true, numericality: { greater_than: 0 }

    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end

    def fixed?
        discount_type == "fixed"
    end

    def percentage?
        discount_type == "percentage"
    end
end
