# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tournaments_users
  has_many :messages
  has_many :tournaments, through: :tournaments_users
  has_many :users_matches
  has_many :matches, through: :users_matches
  has_one_attached :avatar
  enum role: %w[member admin]
  validates :phone_number, presence: true,
                           numericality: true,
                           length: { minimum: 10, maximum: 15 }
  devise :registerable, :two_factor_authenticatable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable,
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']

  def self.generate_otp_secret
    ROTP::Base32.random_base32
  end

  def self.generate_otp(secret_key)
    totp = ROTP::TOTP.new(secret_key)
    totp.now
  end

  def self.auth_with_2fa(otp_attempt, user)
    return unless user.validate_and_consume_otp!(otp_attempt)

    user.save
  end

  def total_matches_played
    matches.size
  end

  def total_matches_won
    matches.winner_count(id)
  end

  def total_tournaments_played
    tournaments.size
  end

  def total_tournaments_won
    tournaments.winner_count(id)
  end

  def id_and_name
    pluck(:id, :name).to_h
  end
end
