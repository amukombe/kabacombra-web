class Driver < ApplicationRecord
  belongs_to :employee
  has_many :truck_drivers
  has_many :trucks, through: :truck_drivers
  has_many :order_drivers
  has_many :orders, through: :order_drivers, dependent: :destroy
  def self.search(params)
    if params[:query].blank?
      all
    else
      joins(:employee).where("employees.firstname LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
    end
  end

  def name
    "#{self.employee.firstname} #{self.employee.lastname}"
  end
end
