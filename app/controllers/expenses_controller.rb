class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]

  # GET /expenses or /expenses.json
  def index
    @expenses = Expense.search(params).page(params[:page]).per(20)
  end

  # GET /expenses/1 or /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @expense_types = ExpenseType.all
    @employees = current_territory.employees #Employee.joins(employee_territory).where(employee_territories:{territory_id: current_territory.id})
  end

  # GET /expenses/1/edit
  def edit
    @expense_types = ExpenseType.all
  end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense_types = ExpenseType.all
    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    @expense_types = ExpenseType.all
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html { redirect_to expenses_path, status: :see_other, notice: "Expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def  approvals
    status_id = 8
    @expenses = Expense.my_approvals(params, current_territory.id, current_user.id, status_id).page(params[:page]).per(20)
  end

  def approve
    @expense = Expense.find(params[:id])
    @expense.update(status_id: 9)
    redirect_to "/expense_approvals", notice: "Expense successfully approved"
  end

  def acknowledge
    @expense = Expense.find(params[:id])
    @expense.update(status_id: 11)
    redirect_to "/expense_approvals", notice: "Money receipt successfully akcnowledged"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:expense_type_id, :user_id, :territory_id, :status_id, :expense_title, :received_by, :authorized_by, :reason, :description, :expense_date, :amount, :source_of_income)
    end
end
