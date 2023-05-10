# frozen_string_literal: true

class SelectionController < ApplicationController
  # before_action :authenticate_user!, except: [:home]

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

  def index
    @match = Match.where(id: params[:selection][:match_id])
    @selections = @match.find_by_match_and_user(params[:user_id])
  end

  # def result
  #   @match = Match.find(params[:selection][:match_id])
  #   opponent_user_id = @match.opponent_user_id(current_user.id)
  #   @current_user_selections = @match.user_selections(current_user.id)
  #   @opponent_user_selections = @match.user_selections(opponent_user_id)
  #   @current_user_latest_selection = @current_user_selections.last
  #   current_try = @current_user_latest_selection.try_num
  #   sleep(0.5)
  #   @opponent_user_selections.each do |selection|
  #     @opponent_user_latest_selection = selection if selection.try_num == current_try
  #   end
  #   return unless !@current_user_selections.nil? || !@opponent_user_latest_selection.nil?

  #   check_winner(@current_user_latest_selection, @opponent_user_latest_selection, opponent_user_id)
  # end

  # def try_result_broadcast(match_id, user1_selection, user2_selection)
  #   user1_id = user1_selection.selection
  #   user2_id = user2_selection.selection
  #   status1 = user1_selection.status
  #   status2 = user2_selection.status
  #   ActionCable.server.broadcast("timer_channel_#{match_id}",
  #                                { id1: user1_id, id2: user2_id, status1:, selection1: user1_selection.selection,
  #                                  selection2: user2_selection.selection, status2: })
  # end

  private

  def selection_params
    # byebug
    params.require(:selection).permit(:match_id, :user, :selection)
  end
end
