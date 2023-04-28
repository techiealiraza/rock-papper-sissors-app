class Match < ApplicationRecord
  paginates_per 3
  belongs_to :tournament
  has_many :messages
  has_many :users_matches
  has_many :users, through: :users_matches
  has_many :selections
end

def started?
  start_time < Time.now
end
