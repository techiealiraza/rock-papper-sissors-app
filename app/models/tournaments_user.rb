# frozen_string_literal: true

class TournamentsUser < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  validates :user_id, uniqueness: { scope: :tournament_id }
end
