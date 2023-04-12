class Selection < ApplicationRecord
  belongs_to :match

  def self.findByMatchAndUser(match_id, user_id)
    where(match_id:, user_id:)
  end
end
