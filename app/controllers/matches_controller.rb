# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: [:index]

  def index
    tournament = Tournament.find(params[:tournament_id])
    @matches = []
    @matches = tournament.matches.page(params[:page])
  end

  def matches_index
    match = Match.find(params[:match_id])
    @players = match.users
  end

  def show
    @match = Match.find(params[:id])
    @usermatches = @match.users
  end

  def new
    @match = Match.new
  end

  def playmatch
    @match = Match.find(params[:match_id])
    @players = @match.users
    @remaining_tries = @match.remaining_tries(@players.first.id)
    @done_tries = @match.done_tries_num(@players.first.id)
    # @current_user_selections = @match.user_selections(@players.first.id)
    # @opponent_user_selections = @match.user_selections(@players.last.id)
    # @current_user_scores = @current_user_selections.winner.size
    # @opponent_user_scores = @opponent_user_selections.winner.size
    @is_player = @match.users.include?(current_user)

    return if @match.match_winner_id.nil?

    redirect_to match_result_path(@match)
  end

  # POST /matches or /matches.json
  def create_matches
    tournament_id = params[:tournament_id]
    tournament = Tournament.find(tournament_id)
    registered_users = tournament.users
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

  # def group_by_two(registered_users, tournament)
  #   matches = []
  #   registered_users.each_slice(2) do |user1, user2|
  #     match_start_time = tournament.start_date + 3.seconds
  #     match = Match.create(tournament_id: tournament.id, match_time: match_start_time)
  #     match_broadcast_job(match.match_time - 5.hours + 5.seconds, match.id, 1, match.tries)
  #     matches << user_match_obj(match, user1)
  #     matches << user_match_obj(match, user2)
  #   end
  #   matches
  # end

  # def match_broadcast_job(run_at, match_id, try_num, tries)
  #   3.times do
  #     MatchBroadcastJob.delay(run_at:).perform_later(match_id, try_num, tries)
  #     run_at += 1.seconds
  #     try_num += 1
  #   end
  # end

  def result
    @match = Match.find(params[:match_id])
    players = @match.users
    @player1_name = players.first.name
    @player2_name = players.last.name
    @current_user_selections = @match.user_selections(players.first.id)
    @opponent_user_selections = @match.user_selections(players.last.id)
    @current_user_scores = @current_user_selections.winner.size
    @opponent_user_scores = @opponent_user_selections.winner.size
    @result_message = @match.result_message(current_user.id)
  end

  # def user_match_obj(match, user)
  #   UsersMatch.new(match:, user:)
  # end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_url(@match), notice: 'Match was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:match_winner_id, :winner_score, :match_time, :tournament_id)
  end
end
