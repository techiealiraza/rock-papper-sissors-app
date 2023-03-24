class Tournament < ApplicationRecord
  has_many :tournaments_users
  has_many :users, through: :tournaments_users
end
