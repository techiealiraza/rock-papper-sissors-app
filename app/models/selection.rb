# frozen_string_literal: true

class Selection < ApplicationRecord
  belongs_to :match
  scope :winner, -> { where(winner: true) }

  def update_winner
    self.winner = true
    save
  end

  def add_try_num
    match = Match.find(match_id)
    done_tries_num = match.done_tries_num(user)
    self.try_num = match.tries - (match.tries - done_tries_num)
  end

  def status
    user_name = User.find(user).name
    return unless winner.is_a?(TrueClass)

    "#{user_name} won"
  end
end
