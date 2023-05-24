# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :authenticate_2fa!, only: %i[create]
    before_action :authenticate_user!, except: %i[new create destroy]
    skip_authorization_check only: %i[new create]

    def authenticate_2fa!
      user = self.resource = find_user(session[:user_id], user_params[:email])
      return unless user

      byebug

      TwoFactorAuth.new(user).authenticate_2fa(user_params[:otp_attempt], user_params[:password])
      render 'user_otp/two_fa'
    end

    def find_user(session_user_id, email_address)
      if session_user_id
        User.find_by(id: session_user_id)
      elsif email_address
        User.find_by(email: email_address)
      end
    end

    def user_params
      params.require(:user).permit(:email, :password, :otp_attempt, :remember_me)
    end

    # GET /resource/sign_in
    def new
      super do |resource|
        if resource.valid? && resource.persisted?
          resource.update(
            otp_required_for_login: true
          )
        end
      end
    end

    def create
      super do |resource|
        if resource.valid? && resource.persisted?
          resource.update(
            otp_required_for_login: true
          )
        end
      end
    end
  end
end
