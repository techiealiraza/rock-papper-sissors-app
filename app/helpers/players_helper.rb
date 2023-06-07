# frozen_string_literal: true

# players helper
module PlayersHelper
  def players(players)
    players_ids = players.keys
    return players_ids if players_ids.exclude?(current_user.id)

    player1_id = current_user.id
    player2_id = players.reject { |player| player == player1_id }.keys.first
    [player1_id, player2_id]
  end
end
