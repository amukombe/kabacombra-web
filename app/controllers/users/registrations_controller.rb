class Users::RegistrationsController < ApplicationController
    before_action :configure_permitted_parameters

    # Customize the registration create action if needed
    def create
        super
    end

    private

    # Permit additional parameters for sign up
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :referral_code])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
end
