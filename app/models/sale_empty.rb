class SaleEmpty < ApplicationRecord
  belongs_to :sale
  belongs_to :empty_type
  validates :expected, :received, :variance, presence:true
end
