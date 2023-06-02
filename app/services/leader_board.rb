# match_creator service
class LeaderBoard
  def result
    data = []
    User.all.each do |user|
      tournaments_won = user.total_tournaments_won
      data << { user:, tournaments_won: }
    end
    top_players(data)
  end

  private

  def top_players(data)
    top_tournaments_winners = data.sort_by! { |record| record[:tournaments_won] }.reverse!.take(10)
    top_tournaments_winners.each do |record|
      matches_played = record[:user].total_matches_played
      tournaments_played = record[:user].total_tournaments_played
      matches_won = record[:user].total_matches_won
      record.merge!({ matches_played:, tournaments_played:, matches_won: })
    end
    top_tournaments_winners
  end
end
