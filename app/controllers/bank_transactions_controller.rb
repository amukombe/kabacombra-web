class BankTransactionsController < ApplicationController
  before_action :set_active_link

  def index
    @active_link = "bank_transactions"
    load_filters
    load_transactions
    load_summary
  end

  def show
    @transaction =
      current_territory
        .bank_transactions
        .includes(
          :bank_account,
          :financial_transaction,
          :user
        )
        .find(params[:id])
  end

  private

  def set_active_link
    @active_link = "banking"
  end

  ####################################
  # Filters
  ####################################

  def load_filters
    params[:start_date] ||= Date.current.beginning_of_month
    params[:end_date] ||= Date.current

    @accounts =
      current_territory
        .bank_accounts
        .order(:account_name)
  end

  ####################################
  # Transactions
  ####################################

  def load_transactions

    @transactions =
      current_territory
        .bank_transactions
        .includes(
          :bank_account,
          :financial_transaction,
          :user
        )

    ####################################
    # Date Filter
    ####################################

    @transactions =
      @transactions.where(
        cleared_date:
          params[:start_date]..
          params[:end_date]
      )

    ####################################
    # Bank Account
    ####################################

    if params[:bank_account_id].present?

      @transactions =
        @transactions.where(
          bank_account_id:
            params[:bank_account_id]
        )

    end

    ####################################
    # Transaction Type
    ####################################

    if params[:transaction_type].present?

      @transactions =
        @transactions.where(
          transaction_type:
            params[:transaction_type]
        )

    end

    ####################################
    # Search
    ####################################

    if params[:query].present?

      search =
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"

      @transactions =
        @transactions.joins(:bank_account)
                     .where(
      "
      cheque_number LIKE :search
      OR transaction_type LIKE :search
      OR method LIKE :search
      OR bank_accounts.account_name LIKE :search
      ",
      search: search
      )

    end

    @transactions =
      @transactions
        .order(
          cleared_date: :desc,
          created_at: :desc
        )
        .page(params[:page])
        .per(25)

  end

  ####################################
  # Summary Cards
  ####################################

  def load_summary

    scope =
      @transactions.except(
        :limit,
        :offset,
        :order
      )

    @total_transactions =
      scope.count

    @total_debits =
      scope.where(
        method: "deposit"
      ).sum(:amount)

    @total_credits =
      scope.where
           .not(method: "deposit")
           .sum(:amount)

    @net_cashflow =
      @total_debits -
      @total_credits

  end

end