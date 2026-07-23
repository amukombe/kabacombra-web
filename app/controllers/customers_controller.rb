class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy statement]

  # GET /customers or /customers.json
  def index
    @customers = Customer.search(params).page(params[:page]).per(10)
  end

  def statement
    set_statement_default_dates

    @active_link = "customer_statements"

    @sales = filtered_customer_sales
    @payments = filtered_customer_payments
    @adjustments = filtered_customer_adjustments

    @credit_memos = @customer
                      .customer_credit_memos
                      .includes(:credit_memo_allocations)
                      .where(memo_date: statement_date_range)
                      .order(:memo_date, :id)

    load_goods_summary
    load_financial_summary
    build_statement_transactions
  end

  def statements_summary
    set_statement_default_dates

    @active_link = "customer_statements"

    customers_scope =
      current_territory
        .customers
        .includes(
          sales: [
            :sale_items,
            :payment_allocations,
            :customer_adjustments
          ],
          sale_payments:
            :payment_allocations
        )

    if params[:query].present?
      search =
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"

      customers_scope =
        customers_scope.where(
          "customers.name LIKE :search
           OR customers.mobile LIKE :search
           OR customers.brn LIKE :search",
          search: search
        )
    end

    @customers =
      customers_scope
        .order(:name)
        .page(params[:page])
        .per(20)

    load_customer_statement_summary_rows
    load_overall_customer_statement_totals
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)
    @customer.territory = current_territory
    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customers_path, notice: "Customer was successfully updated." }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy!

    respond_to do |format|
      format.html { redirect_to customers_path, status: :see_other, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def autocomplete
    customers = Customer
                  .where("name LIKE ?", "%#{params[:q]}%")
                  .limit(10)

    render json: customers.map { |c|
      {
        id: c.id,
        name: c.name,
        mobile: c.mobile,
        brn: c.brn
      }
    }
  end

  private
    def set_statement_default_dates
      params[:start_date] ||=
        Date.current.beginning_of_month.to_s

      params[:end_date] ||=
        Date.current.to_s
    end

    def statement_date_range
      start_date =
        Date.parse(params[:start_date].to_s)

      end_date =
        Date.parse(params[:end_date].to_s)

      start_date.beginning_of_day..
        end_date.end_of_day
    rescue ArgumentError
      Date.current.beginning_of_month.beginning_of_day..
        Date.current.end_of_day
    end

    def filtered_customer_sales
      @customer
        .sales
        .includes(
          sale_items: :nile_product,
          payment_allocations: :sale_payment,
          customer_adjustments: :customer_adjustment_items
        )
        .where(
          sale_date: statement_date_range
        )
        .order(:sale_date, :id)
    end

    def filtered_customer_payments
      @customer
        .sale_payments
        .includes(
          :sale,
          payment_allocations: :sale
        )
        .where(
          payment_date: statement_date_range
        )
        .order(:payment_date, :id)
    end

    def filtered_customer_adjustments
      @customer
        .customer_adjustments
        .includes(:sale)
        .where(
          adjustment_date: statement_date_range
        )
        .order(:adjustment_date, :id)
    end

    def load_goods_summary
      sale_items = SaleItem
                    .joins(:sale, :nile_product)
                    .where(
                      sales: {
                        customer_id: @customer.id,
                        sale_date: statement_date_range
                      }
                    )

      raw_goods = sale_items
                    .group(
                      :nile_product_id,
                      "nile_products.name"
                    )
                    .pluck(
                      :nile_product_id,
                      "nile_products.name",
                      Arel.sql(
                        "SUM(sale_items.quantity_ordered)"
                      ),
                      Arel.sql(
                        "SUM(sale_items.quantity_sold)"
                      )
                    )

      @goods_summary = raw_goods.map do |
        product_id,
        product_name,
        quantity_ordered,
        quantity_delivered
      |

        ordered = quantity_ordered.to_d
        delivered = quantity_delivered.to_d

        {
          product_id: product_id,
          product_name: product_name,
          ordered: ordered,
          delivered: delivered,
          balance: ordered - delivered
        }
      end

      @total_quantity_ordered =
        @goods_summary.sum do |row|
          row[:ordered]
        end

      @total_quantity_delivered =
        @goods_summary.sum do |row|
          row[:delivered]
        end

      @total_quantity_balance =
        @goods_summary.sum do |row|
          row[:balance]
        end
    end

    def load_financial_summary
      @total_invoiced = @sales.sum do |sale|
        sale.total_price.to_d
      end

      approved_adjustments =
        @adjustments.select(&:approved?)

      @total_debit_notes =
        approved_adjustments
          .select(&:debit_note?)
          .sum do |adjustment|
            adjustment.total_amount.to_d
          end

      @total_credit_notes =
        approved_adjustments
          .select(&:credit_note?)
          .sum do |adjustment|
            adjustment.total_amount.to_d
          end

      @adjusted_invoice_total =
        @total_invoiced.to_d +
        @total_debit_notes.to_d -
        @total_credit_notes.to_d

      @total_payments_received =
        @payments.sum do |payment|
          payment.amount.to_d
        end

      @total_allocated_payments =
        PaymentAllocation
          .joins(:sale_payment, :sale)
          .where(
            sale_payments: {
              customer_id: @customer.id
            },
            sales: {
              sale_date: statement_date_range
            }
          )
          .sum(:amount)

      @outstanding_balance =
        @customer
          .sales
          .includes(
            :sale_items,
            :payment_allocations,
            :customer_adjustments
          )
          .sum do |sale|
            [sale.balance.to_d, 0].max
          end

      @available_credit =
        @customer
          .sale_payments
          .includes(:payment_allocations)
          .sum do |payment|
            payment.available_amount.to_d
          end

      @net_account_balance =
        @outstanding_balance.to_d -
        @available_credit.to_d

      @approved_credit_memos =
        @customer
          .customer_credit_memos
          .approved
          .includes(:credit_memo_allocations)

      @total_credit_memo_amount =
        @approved_credit_memos.sum(:amount)

      @allocated_credit_memo_amount =
        @approved_credit_memos.sum do |memo|
          memo.allocated_amount.to_d
        end

      @available_credit_memo_amount =
        @approved_credit_memos.sum do |memo|
          memo.available_amount.to_d
        end

      @available_payment_credit =
        @customer
          .sale_payments
          .includes(:payment_allocations)
          .sum do |payment|
            payment.available_amount.to_d
          end

      @available_credit =
        @available_payment_credit.to_d +
        @available_credit_memo_amount.to_d
    end

    def build_statement_transactions
      transactions = []

      # Sales / invoices
      @sales.each do |sale|
        transactions << {
          date: sale.sale_date,
          sort_order: 1,
          record_id: sale.id,
          document: sale.invoice_no.presence || sale.receipt_no,
          description: "Sale invoice",
          debit: sale.total_price.to_d,
          credit: 0.to_d,
          path: sale_path(sale)
        }
      end

      # Approved debit and credit notes
      @adjustments.each do |adjustment|
        next unless adjustment.approved?

        if adjustment.debit_note?
          transactions << {
            date: adjustment.adjustment_date,
            sort_order: 2,
            record_id: adjustment.id,
            document: adjustment.adjustment_number,
            description: "Debit note",
            debit: adjustment.total_amount.to_d,
            credit: 0.to_d,
            path: customer_adjustment_path(adjustment)
          }
        elsif adjustment.credit_note?
          transactions << {
            date: adjustment.adjustment_date,
            sort_order: 2,
            record_id: adjustment.id,
            document: adjustment.adjustment_number,
            description: "Credit note",
            debit: 0.to_d,
            credit: adjustment.total_amount.to_d,
            path: customer_adjustment_path(adjustment)
          }
        end
      end

      # Approved customer credit memos
      @credit_memos.each do |memo|
        next unless memo.approved?

        transactions << {
          date: memo.memo_date,
          sort_order: 3,
          record_id: memo.id,
          document: memo.memo_number,
          description: "Credit memo - #{memo.memo_type.humanize}",
          debit: 0.to_d,
          credit: memo.amount.to_d,
          path: customer_credit_memo_path(memo)
        }
      end

      # Customer payments
      @payments.each do |payment|
        transactions << {
          date: payment.payment_date,
          sort_order: 4,
          record_id: payment.id,
          document: payment.receipt_number,
          description: "Payment received",
          debit: 0.to_d,
          credit: payment.amount.to_d,
          path: payment.sale.present? ?
                  sale_sale_payment_path(payment.sale, payment) :
                  nil
        }
      end

      transactions.sort_by! do |transaction|
        [
          transaction[:date] || Date.current,
          transaction[:sort_order],
          transaction[:record_id]
        ]
      end

      running_balance = 0.to_d

      @statement_transactions = transactions.map do |transaction|
        running_balance +=
          transaction[:debit].to_d -
          transaction[:credit].to_d

        transaction.merge(
          running_balance: running_balance
        )
      end
    end

    def load_customer_statement_summary_rows
      @customer_statement_rows =
        @customers.map do |customer|

          customer_sales =
            customer.sales.select do |sale|
              sale.sale_date.present? &&
                statement_date_range.cover?(sale.sale_date)
            end

          customer_payments =
            customer.sale_payments.select do |payment|
              payment.payment_date.present? &&
                statement_date_range.cover?(payment.payment_date)
            end

          customer_adjustments =
            customer.customer_adjustments.select do |adjustment|
              adjustment.approved? &&
                adjustment.adjustment_date.present? &&
                statement_date_range.cover?(
                  adjustment.adjustment_date
                )
            end

          credit_memos =
            customer.customer_credit_memos.select do |memo|
              memo.approved? &&
                memo.memo_date.present? &&
                statement_date_range.cover?(memo.memo_date)
            end

          invoiced =
            customer_sales.sum do |sale|
              sale.total_price.to_d
            end

          debit_notes =
            customer_adjustments
              .select(&:debit_note?)
              .sum do |adjustment|
                adjustment.total_amount.to_d
              end

          credit_notes =
            customer_adjustments
              .select(&:credit_note?)
              .sum do |adjustment|
                adjustment.total_amount.to_d
              end

          payments =
            customer_payments.sum do |payment|
              payment.amount.to_d
            end

          credit_memo_total =
            credit_memos.sum do |memo|
              memo.amount.to_d
            end

          credit_memo_allocated =
            credit_memos.sum do |memo|
              memo.allocated_amount.to_d
            end

          credit_memo_available =
            credit_memos.sum do |memo|
              memo.available_amount.to_d
            end

          outstanding =
            customer.sales.sum do |sale|
              [sale.balance.to_d, 0.to_d].max
            end

          available_payment_credit =
            customer.sale_payments.sum do |payment|
              payment.available_amount.to_d
            end

          total_available_credit =
            available_payment_credit.to_d +
            credit_memo_available.to_d

          ordered =
            customer_sales.sum do |sale|
              sale.sale_items.sum do |item|
                item.quantity_ordered.to_d
              end
            end

          delivered =
            customer_sales.sum do |sale|
              sale.sale_items.sum do |item|
                item.quantity_sold.to_d
              end
            end

          {
            customer: customer,
            invoiced: invoiced,
            debit_notes: debit_notes,
            credit_notes: credit_notes,

            credit_memos: credit_memo_total,
            credit_memos_allocated: credit_memo_allocated,
            credit_memos_available: credit_memo_available,

            payments: payments,
            outstanding: outstanding,

            available_payment_credit: available_payment_credit,
            available_credit: total_available_credit,

            net_balance:
              outstanding.to_d -
              total_available_credit.to_d,

            ordered: ordered,
            delivered: delivered,

            quantity_balance:
              ordered.to_d -
              delivered.to_d
          }
        end
    end

    def load_overall_customer_statement_totals
      @summary_total_invoiced =
        @customer_statement_rows.sum do |row|
          row[:invoiced]
        end

      @summary_total_debit_notes =
        @customer_statement_rows.sum do |row|
          row[:debit_notes]
        end

      @summary_total_credit_notes =
        @customer_statement_rows.sum do |row|
          row[:credit_notes]
        end

      @summary_total_payments =
        @customer_statement_rows.sum do |row|
          row[:payments]
        end

      @summary_total_outstanding =
        @customer_statement_rows.sum do |row|
          row[:outstanding]
        end

      @summary_total_available_credit =
        @customer_statement_rows.sum do |row|
          row[:available_credit]
        end

      @summary_net_balance =
        @summary_total_outstanding.to_d -
        @summary_total_available_credit.to_d

      @summary_total_ordered =
        @customer_statement_rows.sum do |row|
          row[:ordered]
        end

      @summary_total_delivered =
        @customer_statement_rows.sum do |row|
          row[:delivered]
        end

      @summary_quantity_balance =
        @summary_total_ordered.to_d -
        @summary_total_delivered.to_d

      @summary_total_credit_memos =
        @customer_statement_rows.sum do |row|
          row[:credit_memos]
        end

      @summary_credit_memos_allocated =
        @customer_statement_rows.sum do |row|
          row[:credit_memos_allocated]
        end

      @summary_credit_memos_available =
        @customer_statement_rows.sum do |row|
          row[:credit_memos_available]
        end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:name, :email, :mobile, :location, :brn)
    end
end
