# LeaderBoard Controller
class LeaderboardController < ApplicationController
  def index
    @players = LeaderBoard.new.result
  end
end
