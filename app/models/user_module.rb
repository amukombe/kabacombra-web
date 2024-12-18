class UserModule < ApplicationRecord
  belongs_to :system_module
  belongs_to :user
  belongs_to :territory
end
