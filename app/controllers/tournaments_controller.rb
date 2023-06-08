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
      flash[:notice] = 'You have registered for the tournament!.'
    else
      flash[:errors] = @tournament.errors.full_messages.join(', ')
    end
    redirect_to tournament_url(@tournament)
  end

  def create_matches
    TournamentMatchCreator.new(@tournament, @tournament.users).call
    redirect_to tournament_path(@tournament)
    flash[:notice] = 'Matches Generated.'
  rescue StandardError => e
    redirect_to tournament_path(@tournament)
    flash[:alert] = "Error generating matches: #{e.message}"
  end

  def create
    if @tournament.save
      redirect_to tournament_url(@tournament)
      flash[:notice] = 'Tournament was successfully created.'
    else
      render :new
      flash[:errors] = @tournament.errors.full_messages.join(', ')
    end
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to tournament_url(@tournament)
      flash[:notice] = 'Tournament was successfully updated.'
    else
      flash[:errors] = @tournament.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if @tournament.destroy
      redirect_to tournaments_url
      flash[:notice] = 'Tournament was successfully deleted.'
    else
      flash[:errors] = @tournament.errors.full_messages.join(', ')
      render :index
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
