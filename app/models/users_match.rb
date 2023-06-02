# frozen_string_literal: true

class UsersMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match

  def self.opponent_user_id(match_id, current_user_id)
    UsersMatch.where(match_id:).where.not(user_id: current_user_id).pluck(:user_id).first
  end
end
