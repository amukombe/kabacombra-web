class BankStatementsController < ApplicationController
  before_action :set_active_link

  def index
    @active_link = "bank_statements"
    load_filters
    build_statement
  end

  private

  ############################################################
  # Filters
  ############################################################

  def load_filters
    params[:start_date] ||= Date.current.beginning_of_month
    params[:end_date] ||= Date.current

    @accounts =
      current_territory
        .bank_accounts
        .includes(:bank)
        .order(:account_name)

    @account =
      if params[:bank_account_id].present?
        current_territory
          .bank_accounts
          .find(params[:bank_account_id])
      else
        @accounts.first
      end
  end

  ############################################################
  # Build Statement
  ############################################################

  def build_statement
    return unless @account.present?

    statement =
      Statements::BankStatement
        .new(
          bank_account: @account,
          start_date: params[:start_date],
          end_date: params[:end_date]
        )
        .call

    @statement = statement.rows

    summary = statement.summary

    @opening_balance   = summary[:opening_balance]
    @total_deposits    = summary[:total_debits]
    @total_withdrawals = summary[:total_credits]
    @closing_balance   = summary[:closing_balance]
  end

  ############################################################

  def set_active_link
    @active_link = "banking"
  end
end