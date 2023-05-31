# app/services/book_creator.rb
class MatchCreator
  def initialize(tournament, registered_users, round = 0)
    @tournament = tournament
    @registered_users = registered_users.shuffle
    @round = round
  end

  def create_match
    data = group_by_two
    matches = data[1]
    user_matches = data[0]
    Match.transaction do
      user_matches.each(&:save!)
    end
    matches.each(&:delayed_job)
  end

  def group_by_two
    user_matches = []
    matches = []
    match_time = @tournament.current_match_time
    @registered_users.each_slice(2) do |user1, user2|
      match = Match.create(tournament_id: @tournament.id, match_time:, round: @round)
      matches << match
      user_matches << user_match_obj(match, user1)
      user_matches << user_match_obj(match, user2)
    end
    [user_matches, matches]
  end

  def user_match_obj(match, user)
    UsersMatch.new(match:, user:)
  end
end
