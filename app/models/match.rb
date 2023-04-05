class Match < ApplicationRecord
  belongs_to :tournament
  has_many :messages
  has_many :users_matches
  has_many :users, through: :users_matches
end
