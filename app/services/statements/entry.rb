module Statements
  class Entry

    attr_accessor :date,
                  :reference,
                  :description,
                  :debit,
                  :credit,
                  :balance,
                  :record,
                  :metadata

    def initialize(
      date:,
      reference: nil,
      description:,
      debit: 0,
      credit: 0,
      balance: 0,
      record: nil,
      metadata: {}
    )

      @date = date
      @reference = reference
      @description = description
      @debit = debit.to_d
      @credit = credit.to_d
      @balance = balance.to_d
      @record = record
      @metadata = metadata

    end

  end
end