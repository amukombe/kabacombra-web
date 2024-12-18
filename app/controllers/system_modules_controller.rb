class SystemModulesController < ApplicationController
  before_action :set_system_module, only: %i[ show edit update destroy ]

  # GET /system_modules or /system_modules.json
  def index
    @system_modules = SystemModule.search(params).page(params[:page]).per(20)
  end

  # GET /system_modules/1 or /system_modules/1.json
  def show
  end

  # GET /system_modules/new
  def new
    @system_module = SystemModule.new
    @departments = Department.all
  end

  # GET /system_modules/1/edit
  def edit
    @departments = Department.all
  end

  # POST /system_modules or /system_modules.json
  def create
    @system_module = SystemModule.new(system_module_params)
    @departments = Department.all
    respond_to do |format|
      if @system_module.save
        format.html { redirect_to system_modules_path, notice: "System module was successfully created." }
        format.json { render :show, status: :created, location: @system_module }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_modules/1 or /system_modules/1.json
  def update
    @departments = Department.all
    respond_to do |format|
      if @system_module.update(system_module_params)
        format.html { redirect_to system_modules_path, notice: "System module was successfully updated." }
        format.json { render :show, status: :ok, location: @system_module }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_modules/1 or /system_modules/1.json
  def destroy
    @system_module.destroy!

    respond_to do |format|
      format.html { redirect_to system_modules_path, status: :see_other, notice: "System module was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_module
      @system_module = SystemModule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def system_module_params
      params.require(:system_module).permit(:name, :module_url, :icon, :department_id)
    end
end
