# app/services/statements/opening_balance_calculator.rb

module Statements
  class OpeningBalanceCalculator

    attr_reader :opening_balance

    ############################################################
    #
    # relation
    #
    # ActiveRecord Relation
    #
    ############################################################
    #
    # start_date
    #
    # Statement start date
    #
    ############################################################
    #
    # debit_column
    #
    # Symbol
    #
    ############################################################
    #
    # credit_column
    #
    # Symbol
    #
    ############################################################

    def initialize(
      relation:,
      start_date:,
      debit_column:,
      credit_column:
    )

      @relation = relation

      @start_date = start_date

      @debit_column = debit_column

      @credit_column = credit_column

      @opening_balance = 0.to_d

    end

    ############################################################

    def call

      previous =
        @relation.where(
          "DATE(created_at) < ?",
          @start_date
        )

      debits =
        previous.sum(@debit_column)

      credits =
        previous.sum(@credit_column)

      @opening_balance =
          debits.to_d -
          credits.to_d

      self

    end

  end
end