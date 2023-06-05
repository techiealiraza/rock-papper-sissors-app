# match_creator service
class LeaderBoard
  def result
    players_ids = Tournament.having('tournament_winner_id IS NOT NULL')
                            .group(:tournament_winner_id)
                            .order(count: :desc)
                            .pluck(:tournament_winner_id)
    User.where(id: players_ids)
  end
end
