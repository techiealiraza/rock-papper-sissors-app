# frozen_string_literal: true

class SelectionController < ApplicationController
  # load_and_authorize_resource
  # before_action :authenticate_user!
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

  private

  def selection_params
    raw_data = params.keys.first
    data = JSON.parse(raw_data)
    { match_id: data['match_id'].to_i, user_id: data['user_id'].to_i, choice: data['choice'] }
  end
end
