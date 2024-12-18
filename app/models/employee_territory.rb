class EmployeeTerritory < ApplicationRecord
  belongs_to :territory
  belongs_to :employee
  validates :employee_id, uniqueness: { scope: :territory_id, message: "is already assigned to this department" }

end
