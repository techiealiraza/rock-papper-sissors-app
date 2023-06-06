# frozen_string_literal: true

# players helper
module PlayersHelper
  def players(players, is_player)
    player1 = if is_player
                players.find do |player|
                  player[:id] == current_user.id
                end
              else
                players.first
              end
    player2 = players.find { |player| player != player1 }
    [player1, player2]
  end
end
