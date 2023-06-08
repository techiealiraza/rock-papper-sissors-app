# frozen_string_literal: true

# match_creator service
class TournamentMatchCreator
  def initialize(tournament, registered_users, round = 0)
    @tournament = tournament
    @registered_users = registered_users.shuffle
    @round = round
    @length = registered_users.length
  end

  def call
    raise StandardError, 'Players should be in range 2 to 32' if @length <= 1 || @length > 32

    raise StandardError, 'Players must be multiple of 8' unless (@length & (@length - 1)).zero?

    time = @tournament.current_match_time
    @registered_users.each_slice(2) do |user1, user2|
      Match.create!(tournament_id: @tournament.id, time:, round: @round,
                    users_matches_attributes: [{ user_id: user1.id }, { user_id: user2.id }])
    end
  end
end
