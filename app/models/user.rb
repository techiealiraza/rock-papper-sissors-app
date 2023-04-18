class User < ApplicationRecord
  has_many :tournaments_users
  has_many :messages
  has_many :tournaments, through: :tournaments_users
  has_many :users_matches
  has_many :matches, through: :users_matches
  has_one_attached :avatar
  devise :two_factor_authenticatable,
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %i[guest member admin super_admin]

  def self.generate_otp_secret
    ROTP::Base32.random_base32
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
