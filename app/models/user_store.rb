class UserStore < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates :store_id, uniqueness: { scope: :user_id }
end
