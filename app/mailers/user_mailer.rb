class UserMailer < ApplicationMailer
    default from: 'blussoffice@gmail.com'

    def user_account_info_email
        @user = params[:user]
        mail(to: @user.email, subject: 'Account Created')  
    end
end
