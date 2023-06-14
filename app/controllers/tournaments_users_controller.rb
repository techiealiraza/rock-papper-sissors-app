# frozen_string_literal: true

class TournamentsUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @tournament_user = TournamentsUser.new(tournament_user_params)
    if @tournament_user.save
      flash[:notice] = 'You have registered for the tournament!'
    else
      flash[:alert] = @tournament_user.errors.full_messages.join(', ')
    end
    redirect_to tournament_path(params[:id])
  end

  private

  def tournament_user_params
    { tournament_id: params[:id].to_i, user_id: current_user.id }
  end
end
