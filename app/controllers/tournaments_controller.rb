# Tournamnets Controller

class TournamentsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index]

  def index
    @tournaments = Tournament.includes(%i[users winner]).all
    @tournaments = @tournaments.order(:registration_deadline).page(params[:page])
  end

  def show; end

  def new; end

  def edit; end

  def register
    @tournaments_user = TournamentsUser.new(user: current_user, tournament: @tournament)
    if @tournaments_user.save
      format.html { redirect_to tournament_url(@tournament), notice: 'You have registered for the tournament!.' }
    else
      format.html { redirect_to tournament_url(@tournament), errors: @tournament.errors.full_messages }
    end
  end

  def create_matches
    registered_users = @tournament.users
    length = registered_users.length
    return unless (length & (length - 1).zero?) && (length != 0)

    begin
      MatchCreator.new(@tournament, registered_users).call
      format.html { redirect_to tournament_path(@tournament), notice: 'Matches Generated' }
    rescue StandardError => e
      format.html { redirect_to tournament_path(@tournament), alert: "Error generating matches: #{e.message}" }
    end
  end

  def create
    respond_to do |format|
      if @tournament.save
        format.html { redirect_to tournament_url(@tournament), notice: 'Tournament was successfully created.' }
      else
        format.html { render :new, { errors: @tournament.errors.full_messages } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to tournament_url(@tournament), notice: 'Tournament was successfully updated.' }
      else
        format.html { render :edit, { errors: @tournament.errors.full_messages } }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @tournament.destroy
        format.html { redirect_to tournaments_url, notice: 'Tournament was successfully deleted.' }
      else
        format.html { render :edit, { errors: @tournament.errors.full_messages } }
      end
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name,
                                       :description,
                                       :start_date,
                                       :end_date,
                                       :winner_id,
                                       :image,
                                       :registration_deadline)
  end
end
