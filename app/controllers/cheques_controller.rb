class ChequesController < ApplicationController
  before_action :set_cheque, only: %i[ show edit update destroy ]

  # GET /cheques or /cheques.json
  def index
    @cheques = Cheque.all
  end

  # GET /cheques/1 or /cheques/1.json
  def show
  end

  # GET /cheques/new
  def new
    @cheque = Cheque.new
  end

  # GET /cheques/1/edit
  def edit
  end

  # POST /cheques or /cheques.json
  def create
    @cheque = Cheque.new(cheque_params)

    respond_to do |format|
      if @cheque.save
        format.html { redirect_to @cheque, notice: "Cheque was successfully created." }
        format.json { render :show, status: :created, location: @cheque }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cheques/1 or /cheques/1.json
  def update
    respond_to do |format|
      if @cheque.update(cheque_params)
        format.html { redirect_to @cheque, notice: "Cheque was successfully updated." }
        format.json { render :show, status: :ok, location: @cheque }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cheques/1 or /cheques/1.json
  def destroy
    @cheque.destroy!

    respond_to do |format|
      format.html { redirect_to cheques_path, status: :see_other, notice: "Cheque was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cheque
      @cheque = Cheque.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cheque_params
      params.require(:cheque).permit(:user_id, :territory_id, :bank_transaction_id, :cheque_number, :payee, :status, :issue_date, :cleared_date)
    end
end
