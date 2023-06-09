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
    registered_users = @tournament.users
    length = registered_users.length

    if (length & (length - 1)).zero?
      flash[:alert] = 'Users must be 8'
      redirect_to tournament_path(@tournament)
    end

    begin
      TournamentMatchesCreator.new(@tournament, registered_users).call
      flash[:notice] = 'Matches Generated.'
      redirect_to tournament_path(@tournament)
    rescue StandardError => e
            flash[:alert] = "Error generating matches: #{e.message}"

      redirect_to tournament_path(@tournament)
    end
  end

  def create
    if @tournament.save
      flash[:notice] = 'Tournament was successfully created.'
      redirect_to tournament_url(@tournament)
    else
      flash[:errors] = @tournament.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Tournament was successfully updated.'
      redirect_to tournament_url(@tournament)
    else
      flash[:errors] = @tournament.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if @tournament.destroy
      flash[:notice] = 'Tournament was successfully deleted.'
      redirect_to tournaments_url
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
