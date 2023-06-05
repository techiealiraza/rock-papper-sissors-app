# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :otp_generate_and_send, only: [:create]
    before_action :authenticate_user!, except: %i[new create destroy]
    before_action :load_and_authorize_resource, except: %i[new create destroy]

    def otp_redirect
      authenticate_2fa!
    end

    private

    def authenticate_2fa!
      return unless otp_attempt_present?

      authenticate_with_2fa(user)
      sign_in(:user, user)
    end

    def otp_generate_and_send
      user = self.resource = find_user
      return unless user

      valid_password_and_otp_required?(user)
      session[:user_id] = user.id
      send_otp_code(user)
      render 'user_otp/two_fa'
    end

    def otp_attempt_present?
      user_params[:otp_attempt].present?
    end

    def authenticate_with_2fa(user)
      User.auth_with_2fa(user_params[:otp_attempt], user)
    end

    def valid_password_and_otp_required?(user)
      user.valid_password?(user_params[:password]) && user.otp_required_for_login
    end

    def send_otp_code(user)
      TwoFactorAuth.new(user).send_otp_code
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
  end
end
