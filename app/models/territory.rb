class Territory < ApplicationRecord
  validates :name, :department_id, presence: true
  belongs_to :department
  has_many :employee_territories
  has_many :employees, through: :employee_territories
  has_many :stores
  def self.search(params)
    params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  def display_name
    return "#{department.name} - #{name}"
  end
end
