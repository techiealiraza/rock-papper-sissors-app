# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :find_tournament, only: %i[index playmatch result]
  before_action :set_match, only: %i[playmatch result]
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index]

  def index
    # tournament = Tournament.find(params[:tournament_id])
    @matches = []
    @matches = @tournament.matches.page(params[:page])
  end

  def matches_index
    # match = Match.find(params[:match_id])
    @players = match.users
  end

  def show
    # @match = Match.find(params[:id])
    @usermatches = @match.users
  end

  def new
    @match = Match.new
  end

  def playmatch
    @players = @match.users
    @remaining_tries = @match.remaining_tries(@players.first.id)
    @done_tries = @match.done_tries_num(@players.first.id)
    @is_player = @match.users.include?(current_user)

    return if @match.match_winner_id.nil?

    redirect_to tournament_match_result_path(@match)
  end

  def create_matches
    # tournament_id = params[:tournament_id]
    # tournament = Tournament.find(tournament_id)
    registered_users = @tournament.users
    matches = MatchCreator.new(tournament, registered_users).create_match
    matches.each(&:delayed_job)
    # length = registered_users.length
    # redirect_to tournament_path(tournament_id), notice: 'Nobody registed for this Tournament' if length.zero?
    # if (length - 8).zero?
    # matches = group_by_two(registered_users, tournament)
    # else
    # redirect_to tournament_path(tournament_id), notice: 'Enrolled Players are less than 8'
    # end
    # Match.transaction do
    #   matches.each(&:save!)
    # end
    redirect_to tournament_path(tournament_id), notice: 'Matches Generated'
  end

  def result
    byebug
    # @match = Match.find(params[:match_id])
    players = @match.users
    @player1_name = players.first.name
    @player2_name = players.last.name
    @player1_selections = @match.user_selections(players.first.id)
    @player2_selections = @match.user_selections(players.last.id)
    @player1_scores = @player1_selections.winner.size
    @player2_scores = @player2_selections.winner.size
    @result_message = @match.result_message(current_user.id)
  end

  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_url(@match), notice: 'Match was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def set_match
    @match = Match.find(params[:match_id])
  end

  def match_params
    params.require(:match).permit(:match_winner_id, :winner_score, :match_time, :tournament_id)
  end
end
