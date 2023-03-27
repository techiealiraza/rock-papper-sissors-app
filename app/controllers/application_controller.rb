class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?

  def index
    if current_user
      current_user.otp_required_for_login = true
      current_user.otp_secret = User.generate_otp_secret
      current_user.save!
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  protected

  def after_resetting_password_path_for(user)
    new_session_path(user)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password phone_number avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email password phone_number avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end
end
