# match_creator service
class LeaderBoard
  def result
    data = User.all.sort_by(&:total_tournaments_won).reverse.first(10)
    top_players(data)
  end

  private

  def top_players(top_tournaments_winners)
    top_tournaments_winners.map do |player|
      {
        name: player.name,
        tournaments_won: player.total_tournaments_won,
        matches_played: player.total_matches_played,
        tournaments_played: player.total_tournaments_played,
        matches_won: player.total_matches_won
      }
    end
  end
end
