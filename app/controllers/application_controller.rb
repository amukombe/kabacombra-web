class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # in application.rb (Rails3) or environment.rb (Rails2)
  require 'wicked_pdf'
  require 'ostruct'
  helper_method :current_territory
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  

  def current_territory
    @current_territory ||= begin
      if session[:current_territory_id].present?
        Territory.includes(Territory.reflect_on_all_associations.map(&:name))
                .find_by(id: session[:current_territory_id])
      end
    end
  end

  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :employee_id, :is_super])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :is_super])
  end
end
