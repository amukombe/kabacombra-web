class BankImportMappingsController < ApplicationController
  before_action :set_bank_import_mapping, only: %i[ show edit update destroy ]

  # GET /bank_import_mappings or /bank_import_mappings.json
  def index
    @bank_import_mappings = BankImportMapping.all
  end

  # GET /bank_import_mappings/1 or /bank_import_mappings/1.json
  def show
  end

  # GET /bank_import_mappings/new
  def new
    @bank_import_mapping = BankImportMapping.new
  end

  # GET /bank_import_mappings/1/edit
  def edit
  end

  # POST /bank_import_mappings or /bank_import_mappings.json
  def create
    @bank_import_mapping = BankImportMapping.new(bank_import_mapping_params)

    respond_to do |format|
      if @bank_import_mapping.save
        format.html { redirect_to @bank_import_mapping, notice: "Bank import mapping was successfully created." }
        format.json { render :show, status: :created, location: @bank_import_mapping }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_import_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_import_mappings/1 or /bank_import_mappings/1.json
  def update
    respond_to do |format|
      if @bank_import_mapping.update(bank_import_mapping_params)
        format.html { redirect_to @bank_import_mapping, notice: "Bank import mapping was successfully updated." }
        format.json { render :show, status: :ok, location: @bank_import_mapping }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank_import_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_import_mappings/1 or /bank_import_mappings/1.json
  def destroy
    @bank_import_mapping.destroy!

    respond_to do |format|
      format.html { redirect_to bank_import_mappings_path, status: :see_other, notice: "Bank import mapping was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_import_mapping
      @bank_import_mapping = BankImportMapping.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bank_import_mapping_params
      params.require(:bank_import_mapping).permit(:bank_id, :user_id, :date_column, :reference_column, :description_column, :debit_column, :credit_column, :balance_column)
    end
end
