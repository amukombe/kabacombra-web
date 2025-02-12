class User < ApplicationRecord
  enum role: { staff: 0, supplier: 1, admin: 2 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :employee
  has_many :departments, through: :employee
  has_many :user_modules
  has_many :system_modules, through: :user_modules
  has_many :inventories
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? } 
  def self.search(params)
    params[:query].blank? ? all : where("email LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
      
  def send_account_info_email
    UserMailer.with(user: self, message: 'Account Created').user_account_info_email.deliver_now
    rescue StandardError => e
      # Handle any error that occurs
      Rails.logger.error "Failed to send email: #{e.message}"
      puts "FAILED TO SEND: #{e.message}"
      # Optionally, notify the user or take corrective actions
      # Notify user or perform fallback action
    #end
  end
end
