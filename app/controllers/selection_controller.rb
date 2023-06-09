# frozen_string_literal: true

class SelectionController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  def create
    @selection = Selection.new(selection_params)
    @selection.add_try_num

    if @selection.save
      render json: { flash_message: flash.now[:notice] = 'Choice Saved.' }
    else
      render json: { flash_message: flash.now[:alert] = @selection.errors.full_messages.join(', ') }
    end
  end

  private

  def selection_params
    params.require(:selection).permit(:match_id, :user_id, :choice)
  end
end
