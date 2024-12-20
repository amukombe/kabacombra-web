class Customer < ApplicationRecord
    belongs_to :territory
    has_many :sales
end
