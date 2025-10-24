class Territory < ApplicationRecord
  validates :name, :department_id, presence: true
  belongs_to :department
  has_many :employee_territories
  has_many :employees, through: :employee_territories
  has_many :stores
  has_many :warehouses
  has_many :customers
  has_many :inventories
  has_many :inventory_transactions
  has_many :vendor_payments, dependent: :destroy
  has_many :vendor_adjustiments, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_many :bank_deposits, dependent: :destroy
  has_many :bank_withdraws, dependent: :destroy
  has_many :bank_transfers, dependent: :destroy
  has_many :bank_transactions, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :sale_empties, through: :sales, dependent: :destroy
  def self.search(params)
    params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  def display_name
    return "#{department.name} - #{name}"
  end
end
