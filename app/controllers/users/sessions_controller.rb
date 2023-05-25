# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :authenticate_2fa!, only: [:create]
    before_action :authenticate_user!, except: %i[new create destroy]
    before_action :load_and_authorize_resource, except: %i[new create destroy]
    def authenticate_2fa!
      user = self.resource = find_user
      return unless user

      if user_params[:otp_attempt].present?

        auth_with_2fa(user)

      elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
        session[:user_id] = user.id
        @code = User.generate_otp(user.otp_secret)
        CodeMailer.send_code(@code).deliver_later
        # message = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']).messages.create(
        #   body: "your OTP is :: #{@code}",
        #   from: '+15856321481',
        #   to: '+923212674285'
        # )
        # puts message.sid
        render 'user_otp/two_fa'
      end
    end

    def auth_with_2fa(user)
      return unless user.validate_and_consume_otp!(user_params[:otp_attempt])

      user.save
      sign_in(:user, user)
    end

    def find_user
      if session[:user_id]
        User.find(session[:user_id])
      elsif user_params[:email]
        User.find_by(email: user_params[:email])
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
            otp_required_for_login: true,
            encrypted_otp_secret: User.generate_otp_secret
          )
        end
      end
    end

    def create
      super do |resource|
        if resource.valid? && resource.persisted?

          resource.update(
            otp_required_for_login: true,
            otp_secret: User.generate_otp_secret
          )
        end
      end
    end
  end
end
