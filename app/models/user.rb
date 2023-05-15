# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tournaments_users
  has_many :messages
  has_many :tournaments, through: :tournaments_users
  has_many :users_matches
  has_many :matches, through: :users_matches
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :two_factor_authenticatable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable,
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']

  # ROLES = %i[guest member admin super_admin]

  def self.generate_otp_secret
    ROTP::Base32.random_base32
  end

  def self.generate_otp(secret_key)
    totp = ROTP::TOTP.new(secret_key)
    totp.now
  end

  def self.leaderboard
    # User.select('users.name AS Player, COUNT(DISTINCT users_matches.match_id) AS Matches_Played, matches_won_subquery.matches_won_count AS Matches_Won, COUNT(DISTINCT tournaments.id) AS Tournaments_Won')
    #     .joins(:users_matches)
    #     .joins('LEFT JOIN matches ON users_matches.match_id = matches.id')
    #     .joins('LEFT JOIN tournaments ON tournaments.tournament_winner_id = users.id')
    #     .joins('LEFT JOIN (SELECT matches.match_winner_id, COUNT(*) AS matches_won_count FROM matches GROUP BY matches.match_winner_id) AS matches_won_subquery ON matches_won_subquery.match_winner_id = users.id')
    #     .group('users.id, users.name, matches_won_subquery.matches_won_count')
    #     .order('Tournaments_Won DESC')
    User.select('users.name AS Player, COUNT(DISTINCT users_matches.match_id) AS Matches_Played, matches_won_subquery.matches_won_count AS Matches_Won, COUNT(DISTINCT tournaments.id) AS Tournaments_Won, COUNT(DISTINCT users_tournaments.tournament_id) AS Tournaments_Played')
        .joins(:users_matches)
        .joins('LEFT JOIN matches ON users_matches.match_id = matches.id')
        .joins('LEFT JOIN tournaments ON tournaments.tournament_winner_id = users.id')
        .joins('LEFT JOIN (SELECT matches.match_winner_id, COUNT(*) AS matches_won_count FROM matches GROUP BY matches.match_winner_id) AS matches_won_subquery ON matches_won_subquery.match_winner_id = users.id')
        .joins('LEFT JOIN tournaments_users AS users_tournaments ON users.id = users_tournaments.user_id')
        .group('users.id, users.name, matches_won_subquery.matches_won_count')
        .order('Tournaments_Won DESC')
  end

  def member?
    role == 'member'
  end

  def admin?
    role == 'admin'
  end

  def super_admin?
    role == 'super_admin'
  end
end
