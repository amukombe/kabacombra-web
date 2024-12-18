class Employee < ApplicationRecord
    EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :firstname, :lastname, :dob, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    has_one :user
    has_many :employee_departments
    has_many :employee_territories
    has_many :territories, through: :employee_territories
    has_many :departments, through: :territories
    has_many :drivers
    belongs_to :position
    def self.search(params)
        return all if params[:query].blank?
      
        query = sanitize_sql_like(params[:query])
        where("firstname LIKE :query OR middlename LIKE :query OR lastname LIKE :query", query: "%#{query}%")
    end

    def self.in_same_departments_as(current_user)
        if current_user.is_super
            all
        else
            joins(:departments)
            .where(departments: { id: current_user.employee.department_ids })
            .distinct
        end
    end
      
      
    def fullname
        if self.middlename.present?
            return "#{firstname} #{middlename} #{lastname}"
        else
            return "#{firstname} #{lastname}"
        end
    end
end
