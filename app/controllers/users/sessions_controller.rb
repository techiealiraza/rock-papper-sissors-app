# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :generate_and_send_otp, only: [:create]
    before_action :authenticate_user!, except: %i[new create destroy]
    def verify_otp
      authenticate_2fa!
    end

    private

    def authenticate_2fa!
      user = User.find_by(id: session[:user_id])
      if User.auth_with_2fa(user_params[:otp_attempt], user)
        sign_in(:user, user)
        redirect_to root_path, notice: 'OTP consumed Successfully.'
      else
        redirect_to new_user_session_path, alert: 'Invalid OTP code entered.'
      end
    end

    def generate_and_send_otp
      user = self.resource = User.find_by(email: user_params[:email])

      return unless user

      if user.valid_password?(user_params[:password])

        session[:user_id] = user.id
        TwoFactorAuthenticator.new(user).call
        render 'user_otp/two_fa'
      else
        redirect_to new_user_session_path, alert: 'Invalid Password entered.'
      end
    end

    def user_params
      params.require(:user).permit(:authenticity_token, :email, :password, :otp_attempt, :remember_me)
    end
  end
end
