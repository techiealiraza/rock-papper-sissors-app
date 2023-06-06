# frozen_string_literal: true

# Matches_Controller
class MatchesController < ApplicationController
  load_and_authorize_resource :tournament
  load_and_authorize_resource through: :tournament
  skip_load_and_authorize_resource only: :all

  def index
    @matches = @matches.includes([:winner]).desc.page(params[:page])
  end

  def all
    @matches = Match.includes([:winner]).all.page(params[:page])
  end

  def show; end

  def new
    @match = Match.new
  end

  def playmatch
    redirect_to result_tournament_match_path unless @match.winner_id.nil?
    @players_data = @match.users.names_and_ids
    @remaining_tries = @match.remaining_tries
    @is_player = @match.users.include?(current_user)
    @messages = @match.messages.includes([:user]).all.reverse
  end

  def result
    redirect_to playmatch_tournament_match_path if @match.winner_id.nil?
    @is_player = @match.users.include?(current_user)
    @players_data = @match.users.names_and_ids
    @players_selections = @match.selections.includes(:user).order(:try_num).group_by(&:user_id)
    @players_scores = @match.selections.group(:user_id).winner.count
    @result_message = @match.result_message(current_user.id)
  end
end
