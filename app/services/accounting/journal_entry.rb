module Accounting

  class JournalEntry

    attr_accessor \
      :account,

      :debit,

      :credit,

      :description,

      :reference,

      :date,

      :record

    def initialize(

      account:,

      debit: 0,

      credit: 0,

      description:,

      reference:,

      date:,

      record: nil

    )

      @account = account

      @debit = debit.to_d

      @credit = credit.to_d

      @description = description

      @reference = reference

      @date = date

      @record = record

    end

  end

end