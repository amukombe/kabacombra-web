class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.is_super
      render :index
    elsif current_user.role == "admin" && !current_user.is_super
      render :admin
    elsif current_user.role == "staff"
      render :staff
    end
  end
  def admin

  end

  def staff

  end
  def beer
    employee_territories = current_user.employee.employee_territories.joins(:territory).where(territories: { department_id: params[:id] })

    puts "===============#{employee_territories}"
    puts "===============#{employee_territories.count}"
    get_user_department_dashboard(params[:id])
  end
  def energy
    get_user_department_dashboard(params[:id])
  end
  def transport
    get_user_department_dashboard(params[:id])
  end
  def rentals
    get_user_department_dashboard(params[:id])
  end
  def cement
    get_user_department_dashboard(params[:id])
  end

  private
  def get_user_department_dashboard(id)
    @employee_territories = current_user.employee.employee_territories.joins(:territory).where(territories: { department_id: id })
    #if !@employee_territories.present?
      #redirect_to dashboard_path, alert: "You do not have any branches assigned to you in the department"
    #end
  end
end
