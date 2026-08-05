class BankReconciliationsController < ApplicationController
  before_action :set_bank_reconciliation, only: %i[ show edit update destroy ]

  # GET /bank_reconciliations or /bank_reconciliations.json
  def index
    @active_link = "bank_reconciliations"

    @bank_reconciliations =
      current_territory
        .bank_reconciliations
        .includes(
          :bank_account,
          :user
        )

    ####################################
    # Search
    ####################################

    if params[:query].present?

      search =
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"

      @bank_reconciliations =
        @bank_reconciliations.where(
          "reference LIKE :search
          OR status LIKE :search",
          search: search
        )

    end

    ####################################
    # Status
    ####################################

    if params[:status].present?

      @bank_reconciliations =
        @bank_reconciliations.where(
          status: params[:status]
        )

    end

    ####################################
    # Bank Account
    ####################################

    @accounts =
      current_territory
        .bank_accounts
        .order(:account_name)

    if params[:bank_account_id].present?

      @bank_reconciliations =
        @bank_reconciliations.where(
          bank_account_id: params[:bank_account_id]
        )

    end

    ####################################
    # Summary Cards
    ####################################

    scope =
      @bank_reconciliations

    @draft_count =
      scope.draft.count

    @reconciled_count =
      scope.reconciled.count

    @approved_count =
      scope.approved.count

    @total_difference =
      scope.sum(:difference)

    ####################################
    # Pagination
    ####################################

    @bank_reconciliations =
      @bank_reconciliations
        .order(created_at: :desc)
        .page(params[:page])
        .per(20)

  end

  # GET /bank_reconciliations/1 or /bank_reconciliations/1.json
  def show
    @active_link = "bank_reconciliations"

    @transactions =
      @bank_reconciliation
        .bank_account
        .bank_transactions
        .includes(:financial_transaction)
        .where(
          cleared_date:
            @bank_reconciliation.statement_from..
            @bank_reconciliation.statement_to
        )
        .order(
          :cleared_date,
          :created_at
        )

    @matched =
      @bank_reconciliation
        .bank_reconciliation_items
        .matched
        .count

    @unmatched =
      @bank_reconciliation
        .bank_reconciliation_items
        .where(matched: false)
        .count
  end
  # GET /bank_reconciliations/new
  def new
    @active_link = "banking"

    @bank_reconciliation =
      BankReconciliation.new(
        statement_from: Date.current.beginning_of_month,
        statement_to: Date.current
      )

    @accounts =
      current_territory
        .bank_accounts
        .includes(:bank)
        .order(:account_name)
  end

  # GET /bank_reconciliations/1/edit
  def edit
  end

  # POST /bank_reconciliations or /bank_reconciliations.json
  def create
    @active_link = "bank_reconciliations"

    @bank_reconciliation =
      BankReconciliation.new(
        bank_reconciliation_params
      )

    @bank_reconciliation.user = current_user
    @bank_reconciliation.territory = current_territory

    if @bank_reconciliation.save

      redirect_to @bank_reconciliation,
                  notice: "Bank reconciliation created successfully."

    else

      @accounts =
        current_territory
          .bank_accounts
          .includes(:bank)
          .order(:account_name)

      render :new,
            status: :unprocessable_entity

    end
  end

  # PATCH/PUT /bank_reconciliations/1 or /bank_reconciliations/1.json
  def update
    respond_to do |format|
      if @bank_reconciliation.update(bank_reconciliation_params)
        format.html { redirect_to @bank_reconciliation, notice: "Bank reconciliation was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_reconciliation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_reconciliation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_reconciliations/1 or /bank_reconciliations/1.json
  def destroy
    @bank_reconciliation.destroy!

    respond_to do |format|
      format.html { redirect_to bank_reconciliations_path, status: :see_other, notice: "Bank reconciliation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    @active_link = "bank_reconciliations"

    @bank_reconciliation =
      BankReconciliation.find(params[:id])
  end

  def import_statement
  @reconciliation =
    BankReconciliation.find(params[:id])

  unless @reconciliation.statement_file.attached?
    redirect_to @reconciliation,
                alert: "No bank statement has been uploaded."
    return
  end

  mapping =
    BankImportMapping.find_by(
      bank_id: @reconciliation.bank_account.bank_id
    )

  unless mapping
    redirect_to map_columns_bank_reconciliation_path(@reconciliation),
                alert: "Please configure the column mapping first."
    return
  end

  imported = 0

  @reconciliation.statement_file.blob.open do |file|

    extension =
      File.extname(
        @reconciliation.statement_file.filename.to_s
      ).downcase

    case extension

    when ".csv"

      csv =
        CSV.read(
          file.path,
          headers: true
        )

      csv.each do |row|

        BankReconciliationItem.create!(

          bank_reconciliation: @reconciliation,

          bank_date:
            Date.parse(
              row[mapping.date_column].to_s
            ),

          bank_reference:
            row[mapping.reference_column],

          description:
            row[mapping.description_column],

          bank_amount:
            if row[mapping.credit_column].present?
              row[mapping.credit_column]
            else
              row[mapping.debit_column]
            end,

          matched: false,

          cleared: false

        )

        imported += 1

      end

    when ".xlsx", ".xls"

      workbook =
        Roo::Spreadsheet.open(file.path)

      headers =
        workbook.row(1)

      (2..workbook.last_row).each do |i|

        row =
          Hash[
            headers.zip(
              workbook.row(i)
            )
          ]

        BankReconciliationItem.create!(

          bank_reconciliation: @reconciliation,

          bank_date:
            Date.parse(
              row[mapping.date_column].to_s
            ),

          bank_reference:
            row[mapping.reference_column],

          description:
            row[mapping.description_column],

          bank_amount:
            if row[mapping.credit_column].present?
              row[mapping.credit_column]
            else
              row[mapping.debit_column]
            end,

          matched: false,

          cleared: false

        )

        imported += 1

      end

    else

      redirect_to @reconciliation,
                  alert: "Unsupported file format."

      return

    end

  end

  redirect_to @reconciliation,
              notice: "#{imported} bank statement lines imported successfully."

end

  require "csv"

  def download_template

    csv_data = CSV.generate(headers: true) do |csv|

      csv << [
        "Date",
        "Reference",
        "Description",
        "Debit",
        "Credit",
        "Balance"
      ]

      csv << [
        "2026-08-01",
        "DEP00001",
        "Cash Deposit",
        "2500000",
        "",
        "2500000"
      ]

      csv << [
        "2026-08-02",
        "CHQ00015",
        "Cheque Withdrawal",
        "",
        "500000",
        "2000000"
      ]

    end

    send_data csv_data,
              filename: "bank_statement_template.csv",
              type: "text/csv"

  end

  def upload_statement
    @reconciliation = BankReconciliation.find(params[:id])

    if params[:file].blank?
      redirect_to import_bank_reconciliation_path(@reconciliation),
                  alert: "Please select a file."
      return
    end

    # Replace any previously uploaded file
    @reconciliation.statement_file.purge if @reconciliation.statement_file.attached?

    # Save the uploaded file
    @reconciliation.statement_file.attach(params[:file])

    headers =
      read_headers(@reconciliation.statement_file)

    session[:csv_headers] = headers

    redirect_to map_columns_bank_reconciliation_path(@reconciliation)
  end

  def map_columns

    @reconciliation =
        BankReconciliation.find(params[:id])

    @headers =
        session[:csv_headers]

  end

  def save_mapping
    @reconciliation =
      BankReconciliation.find(params[:id])

    mapping =
      BankImportMapping.find_or_initialize_by(
        bank_id: @reconciliation.bank_account.bank_id
      )

    mapping.user = current_user

    mapping.assign_attributes(
      date_column: params[:date_column],
      reference_column: params[:reference_column],
      description_column: params[:description_column],
      debit_column: params[:debit_column],
      credit_column: params[:credit_column],
      balance_column: params[:balance_column]
    )

    mapping.save!

    redirect_to import_statement_bank_reconciliation_path(@reconciliation),
                notice: "Column mapping saved successfully."
  end

  def auto_match

    @bank_reconciliation =
      BankReconciliation.find(params[:id])

    Banking::AutoMatcher.new(
      @bank_reconciliation
    ).call

    redirect_to @bank_reconciliation,
                notice: "Automatic matching completed."

  end


  private
    def read_headers(file_attachment)
      blob = file_attachment.blob

      blob.open do |file|

        extension =
          File.extname(blob.filename.to_s).downcase

        case extension

        when ".csv"

          csv =
            CSV.read(
              file.path,
              headers: true
            )

          csv.headers

        when ".xlsx", ".xls"

          workbook =
            Roo::Spreadsheet.open(file.path)

          workbook.row(1)

        else

          raise "Unsupported file type"

        end

      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_reconciliation
      @bank_reconciliation = BankReconciliation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bank_reconciliation_params
      params
        .require(:bank_reconciliation)
        .permit(
          :bank_account_id,
          :statement_from,
          :statement_to
        )
    end
end
