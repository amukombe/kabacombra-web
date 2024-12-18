class EmployeeDepartment < ApplicationRecord
  belongs_to :employee
  belongs_to :department

  validates :employee_id, uniqueness: { scope: :department_id, message: "is already assigned to this department" }
end
