class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /employees or /employees.json
  def index
    @employees = Employee.search(params).page(params[:page]).per(20)
  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @positions = Position.all
  end

  # GET /employees/1/edit
  def edit
    @positions = Position.all
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)
    @positions = Position.all
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: "Employee was successfully created." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    @positions = Position.all
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: "Employee was successfully updated." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy!

    respond_to do |format|
      format.html { redirect_to employees_path, status: :see_other, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_territory
    @employee = Employee.find(params[:id])
    @territories = Territory.all
    @employee_territory = @employee.employee_territories.build
  end

  def update_territory
    @employee = Employee.find(params[:id])
    @employee_territory = @employee.employee_territories.build(employee_territory_params)

    if @employee_territory.save
      redirect_to employees_path, notice: "Department assigned successfully."
    else
      @territories = Territory.all
      flash.now[:alert] = "Failed to assign department."
      render :assign_territory, status: :unprocessable_entity
    end
  end

  def remove_territory
    @employee_territory = EmployeeTerritory.find(params[:id])
  
    if @employee_territory.destroy
      respond_to do |format|
        format.html { redirect_to employees_path, notice: "Department successfully removed." }
        format.js   # If you want to handle it via JavaScript
      end
    else
      respond_to do |format|
        format.html { redirect_to employees_path, alert: "Failed to remove department." }
        format.js
      end
    end
  end
  
  def drivers
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:firstname, :middlename, :lastname, :email, :mobile, :dob, :position_id, :address, :nssf, :tin)
    end
    def employee_territory_params
      params.require(:employee_territory).permit(:territory_id)
    end
end
