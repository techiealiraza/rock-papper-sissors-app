# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index]

  # GET /tournaments or /tournaments.json
  def index
    @tournaments = @tournaments.order(:registration_deadline).page(params[:page])
  end

  def show; end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit; end

  def register
    @tournaments_user = TournamentsUser.new(user: current_user, tournament: @tournament)
    if @tournaments_user.save
      redirect_to tournament_url(@tournament), notice: 'You have registered for the tournament!'
    else
      redirect_to tournament_url(@tournament), notice: 'Already Registered'
    end
  end

  def create_matches
    registered_users = @tournament.users
    length = registered_users.length
    # redirect_to tournament_path(tournament_id), notice: 'Nobody registed for this Tournament' if length.zero?
    return unless (length - 8).zero?

    MatchCreator.new(@tournament, registered_users).create_match
    redirect_to tournament_path(@tournament), notice: 'Matches Generated'
  end

  def create
    @tournament = Tournament.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to tournament_url(@tournament), notice: 'Tournament was successfully created.' }

      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to tournament_url(@tournament), notice: 'Tournament was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1 or /tournaments/1.json
  def destroy
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully deleted.' }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def tournament_params
    params.require(:tournament).permit(:name, :description, :start_date, :end_date, :tournament_winner_id, :image,
                                       :registration_deadline)
  end
end
