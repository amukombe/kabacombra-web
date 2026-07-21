class Customer < ApplicationRecord
    belongs_to :territory
    has_many :sales, dependent: :destroy
    has_many :customer_adjustments, dependent: :restrict_with_error
    has_many :credit_notes, -> { where(adjustment_type: "credit_note") }, class_name: "CustomerAdjustment"
    has_many :debit_notes, -> { where(adjustment_type: "debit_note") }, class_name: "CustomerAdjustment"

    def self.search(params)
        params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    end

    def available_credit
    credit_notes
        .approved
        .sum do |note|
        note.remaining_amount
        end
    end
end
