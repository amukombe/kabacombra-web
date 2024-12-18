class Department < ApplicationRecord
    has_many :employee_departments
    has_many :employees, through: :employee_departments
    has_many :territories
    validates :name, :icon, presence: true
    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end
end
