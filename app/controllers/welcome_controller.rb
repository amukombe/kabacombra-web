class WelcomeController < ApplicationController
  def beer
    
    emp_territory = EmployeeTerritory.find_by(territory_id: params[:id], employee_id: current_user.employee.id)
    if emp_territory.present?
      set_current_territory(emp_territory.territory.id)
    else
      #flash[" alert"] = "You don't have access to this folder please contact admin"
      redirect_to beers_path, alert: "You don't have access to this folder please contact admin"
    end
  end

  def transport
  end

  def rentals
  end

  def cement
  end

  def energy
  end

  private
  def set_current_territory(territory_id)
    selected_territory = Territory.find(territory_id)
    session[:current_territory_id] = selected_territory.id
  end
end
