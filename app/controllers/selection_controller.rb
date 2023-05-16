# frozen_string_literal: true

class SelectionController < ApplicationController
  before_action :authenticate_user!

  def create
    @selection = Selection.new(selection_params)
    @match = Match.find(params[:selection][:match_id].to_i)
    @done_tries_length = @match.done_tries_num(params[:selection][:user].to_i)
    @selection.add_try_num(@match, @done_tries_length)
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
    params.require(:selection).permit(:match_id, :user, :selection)
  end
end
