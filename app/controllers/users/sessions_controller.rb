# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :authenticate_2fa!, only: [:create]
  # account_sid = 'AC312933a0ff499fcf81e3c4219ad80710'
  # auth_token = '8fe209d1a73ffc6ad9108cd4fa75156c'
  def authenticate_2fa!
    user = self.resource = find_user
    return unless user

    if user_params[:otp_attempt].present?

      auth_with_2fa(user)

    elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
      session[:user_id] = user.id
      CodeMailer.send_code(user).deliver_now
      @code = User.generate_otp(user.otp_secret)
      # message = Twilio::REST::Client.new('AC312933a0ff499fcf81e3c4219ad80710', '8fe209d1a73ffc6ad9108cd4fa75156c').messages.create(
      #   body: "your OTP is :: #{@code}",
      #   from: '+15856321481',
      #   to: '+923212674285'
      # )
      render 'user_otp/two_fa'
      # elsif
      #   flash[:alert] = 'Invalid email or pasadsword'
      #   redirect_to new_user_session_path
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
  # def new
  #   debugger
  #   super do |resource|
  #     if resource.valid? && resource.persisted?
  #       resource.update(
  #         otp_required_for_login: true,
  #         encrypted_otp_secret: User.generate_otp_secret
  #       )
  #     end
  #   end
  # end

  # POST /resource/sign_in
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

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
