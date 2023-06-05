# match_creator service
class LeaderBoard
  def result
    players_ids = Tournament.having('winner_id IS NOT NULL')
                            .group(:winner_id)
                            .order(count: :desc)
                            .pluck(:winner_id)
    User.where(id: players_ids)
  end
end
