# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, except: %i[new create]
  skip_authorization_check only: %i[new create]
  before_action :configure_permitted_parameters, only: %i[create update]

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end

  def create
    super do |resource|
      if resource.valid? && resource.persisted?
        resource.update(
          role: :member,
          otp_required_for_login: true,
          otp_secret: User.generate_otp_secret
        )
      end
    end
  end

  protected

  def after_sign_up_path_for(_resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[avatar name phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar name phone_number])
  end
end
