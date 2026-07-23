class CustomerCreditMemosController < ApplicationController
  before_action :set_customer,
                only: %i[new create]

  before_action :set_credit_memo,
                only: %i[show approve cancel]

  def index
    params[:start_date] ||= Date.current.beginning_of_month.to_s
    params[:end_date] ||= Date.current.to_s

    @credit_memos = CustomerCreditMemo
                      .includes(
                        :customer,
                        :created_by,
                        :approved_by,
                        :credit_memo_allocations
                      )
                      .order(memo_date: :desc, id: :desc)
                      .page(params[:page])
                      .per(20)

    @total_approved = @credit_memos
                        .select(&:approved?)
                        .sum do |memo|
                          memo.amount.to_d
                        end

    @total_allocated = @credit_memos.sum do |memo|
      memo.allocated_amount.to_d
    end

    @total_available = @credit_memos.sum do |memo|
      memo.available_amount.to_d
    end
  end

  def show
  end

  def new
    @credit_memo = @customer.customer_credit_memos.new(
      memo_date: Date.current,
      memo_type: "appreciation",
      memo_number: CustomerCreditMemo.next_memo_number
    )
  end

  def create
    @credit_memo =
      @customer.customer_credit_memos.new(
        credit_memo_params
      )

    @credit_memo.created_by = current_user

    if @credit_memo.save
      redirect_to customer_credit_memo_path(@credit_memo),
                  notice: "Credit memo created successfully."
    else
      render :new,
             status: :unprocessable_entity
    end
  end

  def approve
    ActiveRecord::Base.transaction do
      @credit_memo.approve!(current_user)

      Credits::ApplyCreditMemo.new(
        @credit_memo
      ).call
    end

    redirect_to customer_credit_memo_path(@credit_memo),
                notice: "Credit memo approved successfully."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to customer_credit_memo_path(@credit_memo),
                alert: error.record.errors.full_messages.to_sentence
  end

  def cancel
    @credit_memo.cancel!

    redirect_to customer_credit_memo_path(@credit_memo),
                notice: "Credit memo cancelled successfully."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to customer_credit_memo_path(@credit_memo),
                alert: error.record.errors.full_messages.to_sentence
  end

  private

  def set_customer
    @customer = current_territory
                  .customers
                  .find(params[:customer_id])
  end

  def set_credit_memo
    @credit_memo = CustomerCreditMemo
                     .includes(
                       :customer,
                       :created_by,
                       :approved_by,
                       credit_memo_allocations: :sale
                     )
                     .find(params[:id])
  end

  def credit_memo_params
    params.require(:customer_credit_memo).permit(
      :memo_date,
      :memo_type,
      :amount,
      :reason
    )
  end
end