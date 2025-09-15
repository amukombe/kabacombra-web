class Supplier < ApplicationRecord
    has_many :payments, as: :recipient
end
