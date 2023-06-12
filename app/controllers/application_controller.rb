# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CanCan::AccessDenied, with: :access_denied
  rescue_from ActionController::RoutingError, with: :render_not_found

  def access_denied
    render file: "#{Rails.root}/public/403.html", formats: [:html], status: 403, layout: false
  end

  def record_not_found
    render file: "#{Rails.root}/public/404.html", formats: [:html], status: 404, layout: false
  end

  def render_not_found
    redirect_to root_path, alert: 'The page you requested was not found.'
  end

  def devise_controller?
    is_a?(Devise::SessionsController)
  end

  def handle_not_found
    # Handle the request and display an error message
    render file: "#{Rails.root}/public/404.html", formats: [:html], status: 404, layout: false
  end

  protected

  def after_resetting_password_path_for(user)
    new_session_path(user)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email password phone_number image])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end
end
