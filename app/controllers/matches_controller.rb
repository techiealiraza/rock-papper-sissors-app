# frozen_string_literal: true

# Matches_Controller
class MatchesController < ApplicationController
  load_and_authorize_resource :tournament
  load_and_authorize_resource through: :tournament
  skip_load_and_authorize_resource only: %i[all playmatch]

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
    @match = @tournament.matches.includes([:users]).find(params[:match_id])
    redirect_to result_tournament_match_path(match_id: @match) unless @match.winner_id.nil?
    @players = @match.users
    @remaining_tries = @match.remaining_tries(@players.first.id)
    @done_tries = @match.selections.by_user(@players.first.id).size
    @is_player = @match.users.include?(current_user)
    @messages = @match.messages.includes([:user]).all.reverse
  end

  def result
    @is_player = @match.users.include?(current_user)
    @players = @match.users
    @players_selections = @match.selections.order(:try_num).group_by(&:user_id)
    @players_scores = @match.selections.group(:user_id).winner.count
    @result_message = @match.result_message(current_user.id)
  end
end
