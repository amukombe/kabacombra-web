class SystemModule < ApplicationRecord
  belongs_to :department
  validates :name, presence: true, uniqueness: true
  has_many :user_modules
  has_many :users, through: :user_modules
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
