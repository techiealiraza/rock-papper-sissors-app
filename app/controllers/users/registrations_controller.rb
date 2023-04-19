# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, except: %i[new create]
  skip_authorization_check only: %i[new create]
  before_action :configure_permitted_parameters, only: %i[create update]

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end

  # GET /resource/sign_up
  # def new
  #   debugger
  #   super
  # end

  # POST /resource
  def create
    debugger
    super do |resource|
      if resource.valid? && resource.persisted?
        resource.update(
          role: :member,
          otp_required_for_login: true,
          encrypted_otp_secret: User.generate_otp_secret
        )
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # private

  # def user_params
  #   params.require(:user).permit(:name, :email, :password, :phone_number)
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # Customize the redirect location based on the role of the user
    if resource.admin?
      root_path
    elsif resource.member?
      root_path
    else
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[avatar name phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar name phone_number])
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
