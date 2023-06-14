# LeaderBoard Controller
class LeaderboardController < ApplicationController
  def index
    @players = LeaderBoardCreator.call
  end
end
