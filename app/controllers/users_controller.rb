class UsersController < ApplicationController
  before_action :authenticate_user!
  #before_action :check_admin, only: [:index,:new, :create, :update, :destroy] # Ensure only admins can manage users
  before_action :set_user, only: %i[ show edit update destroy ]
  def index
    @users = User.search(params).page(params[:page]).per(20)
  end

  def new
    @user = User.new
    @employee  = Employee.find(params[:employee_id])
  end
  

  def create
    puts "SAVING USER ...1"
    @user = User.new(user_params)
    puts "SAVING USER ..."
    respond_to do |format|
      @user.send_account_info_email
      if @user.save
        format.html { redirect_to users_path, notice: "User was successfully created." }
        format.json { render :index, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def edit
    @employee  = @user.employee #Employee.find(params[:employee_id])
  end
  def update
    @employee  = @user.employee
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(user_params)
        @user.send_account_info_email
        format.html{redirect_to users_path, notice: "User successfully updated" }
        format.json{render :index, status: :cretated, location: @user}
      else
        format.html{render :edit, status: :unprocessable_entity}
        format.json{render :json, status: :created, location: :unprocessable_entity}
      end
    end
  end

  def show

  end

  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_module
    @user = User.find(params[:id])
    @system_modules = SystemModule.all
    @user_module = @user.user_modules.build
    @territories = @user.employee.territories
  end

  def update_module
    @user = User.find(params[:id])
    @user_module = @user.user_modules.build(user_module_params)
    if @user_module.save
      redirect_to users_path, notice: "Module assigned successfully."
    else
      @territories = Territory.all
      flash.now[:alert] = "Failed to assign module."
      render :assign_module, status: :unprocessable_entity
    end
  end

  def remove_module
    @user_module = UserModule.find(params[:id])
  
    if @user_module.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: "User successfully removed." }
        format.js   # If you want to handle it via JavaScript
      end
    else
      respond_to do |format|
        format.html { redirect_to users_path, alert: "Failed to remove user." }
        format.js
      end
    end
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :employee_id, :is_super, :store_id)
  end
  def user_module_params
    params.require(:user_module).permit(:system_module_id, :territory_id)
  end
  #def check_admin
    #redirect_to error_path, alert: "You are not authorized to access this page." unless current_user.admin?
  #end
end
