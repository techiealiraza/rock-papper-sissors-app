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

  ROLES = %i[guest member admin super_admin]

  def self.generate_otp_secret
    ROTP::Base32.random_base32
  end

  def self.generate_otp(secret_key)
    totp = ROTP::TOTP.new(secret_key)
    totp.now
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
