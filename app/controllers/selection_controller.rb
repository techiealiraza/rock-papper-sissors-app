# frozen_string_literal: true

class SelectionController < ApplicationController
  before_action :authenticate_user!
  def create
    @selection = Selection.new(selection_params)
    @selection.add_try_num
    respond_to do |format|
      if @selection.save
        format.json { render json: { data: 'Saved' }, status: :ok }
      else
        format.json { render json: { errors: @selection.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def new
    @selection = Selection.new
  end

  private

  def selection_params
    params.require(:selection).permit(:match_id, :user_id, :selection)
  end
end
