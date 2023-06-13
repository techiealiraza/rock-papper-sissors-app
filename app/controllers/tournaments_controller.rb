# frozen_string_literal: true

class TournamentsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index]

  def index
    @tournaments = @tournaments.includes(%i[users winner]).desc.page(params[:page])
  end

  def show; end

  def new; end

  def edit; end

  def create_matches
    begin
      TournamentMatchesCreator.new(@tournament, @tournament.users).call
      flash[:notice] = 'Matches Generated.'
    rescue StandardError => e
      flash[:alert] = "Error generating matches: #{e.message}"
    end
    redirect_to tournament_path(@tournament)
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
