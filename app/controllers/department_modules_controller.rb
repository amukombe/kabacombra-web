class DepartmentModulesController < ApplicationController
  before_action :set_department_module, only: %i[ show edit update destroy ]

  # GET /department_modules or /department_modules.json
  def index
    @department_modules = DepartmentModule.all
  end

  # GET /department_modules/1 or /department_modules/1.json
  def show
  end

  # GET /department_modules/new
  def new
    @department_module = DepartmentModule.new
  end

  # GET /department_modules/1/edit
  def edit
  end

  # POST /department_modules or /department_modules.json
  def create
    @department_module = DepartmentModule.new(department_module_params)

    respond_to do |format|
      if @department_module.save
        format.html { redirect_to @department_module, notice: "Department module was successfully created." }
        format.json { render :show, status: :created, location: @department_module }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @department_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /department_modules/1 or /department_modules/1.json
  def update
    respond_to do |format|
      if @department_module.update(department_module_params)
        format.html { redirect_to @department_module, notice: "Department module was successfully updated." }
        format.json { render :show, status: :ok, location: @department_module }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @department_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /department_modules/1 or /department_modules/1.json
  def destroy
    @department_module.destroy!

    respond_to do |format|
      format.html { redirect_to department_modules_path, status: :see_other, notice: "Department module was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department_module
      @department_module = DepartmentModule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def department_module_params
      params.require(:department_module).permit(:name, :module_url, :department_id)
    end
end
