class Match < ApplicationRecord
  belongs_to :tournament
  has_many :messages
end
