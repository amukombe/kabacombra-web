json.extract! employee, :id, :firstname, :middlename, :lastname, :email, :mobile, :dob, :position, :address, :nssf, :tin, :created_at, :updated_at
json.url employee_url(employee, format: :json)
