class Selection < ApplicationRecord
  belongs_to :match
  before_save :add_try_num

  def self.findByMatchAndUser(match_id, user_id)
    where(match_id:, user: user_id)
  end

  private

  def add_try_num
    @match = Match.where(id: match_id)
    @done_tries = Selection.where(match_id:, user:)
    @done_tries_length = @done_tries.length
    # byebug
    self.try_num = @match[0].tries - (@match[0].tries - @done_tries_length)
  end
end
