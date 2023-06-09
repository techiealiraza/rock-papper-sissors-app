# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)
        respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
      else
        set_flash_message!(:alert, :confirmation_error, reason: resource.errors.messages[:email].first)
        respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
      end
    end

    # protected
    def after_confirmation_path_for(_resource_name, resource)
      sign_in(resource)
      root_path
    end
  end
end
