# match_creator service
class MatchCreator
  def initialize(tournament, registered_users, round = 0)
    @tournament = tournament
    @registered_users = registered_users.shuffle
    @round = round
  end

  def call
    time = @tournament.current_match_time
    @registered_users.each_slice(2) do |user1, user2|
      Match.create!(tournament_id: @tournament.id, time:, round: @round,
                    user_ids: [user1.id, user2.id])
    end
  end
end
