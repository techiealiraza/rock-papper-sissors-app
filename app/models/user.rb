class User < ApplicationRecord
  devise :two_factor_authenticatable,
         otp_secret_encryption_key: ENV['otp_secret_key']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable
end
