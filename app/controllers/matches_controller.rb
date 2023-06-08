# frozen_string_literal: true

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

  def playmatch
    @messages = @match.messages.includes([:user]).all.reverse
    return if @match.done?

    @players_data = @match.users.pluck(:id, :name).to_h
  end

  def result
    return if @match.un_done?

    @players_data = @match.users.pluck(:id, :name).to_h
    @players_selections = @match.selections.includes(:user).order(:try_num).group_by(&:user_id)
    @players_scores = @match.selections.winner.group(:user_id).count
    @result_message = @match.result_message(current_user.id)
  end
end
