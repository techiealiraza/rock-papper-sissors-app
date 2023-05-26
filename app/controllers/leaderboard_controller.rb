# LeaderBoard Controller
class LeaderboardController < ApplicationController
  def index
    @users = User.members
  end
end
