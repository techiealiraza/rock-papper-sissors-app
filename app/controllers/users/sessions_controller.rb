# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :authenticate_2fa!, only: %i[create]
    # before_action :authenticate_user!, except: %i[new create destroy]
    # skip_authorization_check only: %i[new create]
    before_action :authenticate_2fa!, only: [:create]
    before_action :authenticate_user!, except: %i[new create destroy]
    before_action :load_and_authorize_resource, except: %i[new create destroy]

    def authenticate_2fa!
      user = self.resource = find_user
      return unless user

      if user_params[:otp_attempt].present?
        User.auth_with_2fa(user_params[:otp_attempt], user)
        sign_in(:user, user)

      elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
        session[:user_id] = user.id
        TwoFactorAuth.new(user).send_otp_code
        render 'user_otp/two_fa'
      end
    end

    def find_user
      if session[:user_id]
        User.find_by(id: session[:user_id])
      elsif user_params[:email]
        User.find_by(email: user_params[:email])
      end
    end

    def user_params
      params.require(:user).permit(:authenticity_token, :email, :password, :otp_attempt, :remember_me)
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
