class LeaderbordController < ApplicationController
  def index
    @users = User.leaderboard
  end
end
