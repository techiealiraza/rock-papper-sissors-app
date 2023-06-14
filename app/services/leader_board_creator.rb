# frozen_string_literal: true

# leader_board_service
class LeaderBoardCreator
  def self.call
    players_ids = Tournament.having('winner_id IS NOT NULL')
                            .group(:winner_id)
                            .order(count: :desc)
                            .pluck(:winner_id)
                            .take(10)
    User.where(id: players_ids)
  end
end
