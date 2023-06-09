# frozen_string_literal: true

class Selection < ApplicationRecord
  belongs_to :match
  belongs_to :user
  scope :winner, -> { where(winner: true) }
  scope :by_user, ->(user_id) { where(user_id:) }
  scope :by_try_num, ->(try_num) { where(try_num:) }

  def add_try_num
    self.try_num = match.selections.by_user(user_id).size
  end

  def status
    return unless winner

    "#{user.name} won"
  end
end
