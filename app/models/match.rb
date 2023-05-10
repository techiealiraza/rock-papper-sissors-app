# frozen_string_literal: true

class Match < ApplicationRecord
  paginates_per 3
  belongs_to :tournament
  has_many :messages
  has_many :users_matches
  has_many :users, through: :users_matches
  has_many :selections

  def started?
    start_time < Time.now
  end

  def opponent_user_id(current_user_id)
    UsersMatch.where(match_id: id).where.not(user_id: current_user_id).pluck(:user_id).first
  end

  def user_selections(user_id)
    Selection.where(match_id: id, user: user_id)
  end

  def done_tries_num(user)
    Selection.where(match_id: id, user:).size
  end

  def remaining_tries(user)
    done_tries = done_tries_num(user)
    if done_tries
      tries - done_tries
    else
      tries
    end
  end
end
