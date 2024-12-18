class Users::SessionsController < Devise::SessionsController
    layout "home"
    def create
        self.resource = warden.authenticate!(auth_options)
        if resource.deleted_at.present?
        set_flash_message!(:alert, :deleted_account)
        sign_out
        redirect_to new_user_session_path, alert:'Your account was deleted. Please check your email for the restoration link.'
        else
        super
        end
    end
end
  