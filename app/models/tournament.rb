class Tournament < ApplicationRecord
  has_many :tournaments_users
  has_many :users, through: :tournaments_users
  has_many :matches, dependent: :destroy
  validate :end_date_is_after_start_date
  validate :start_date_is_after_end_date
  validate :start_date_validation

  def end_date_is_after_start_date
    return unless end_date < start_date

    errors.add(:end_date, 'Please Check End Date')
  end

  def start_date_is_after_end_date
    return unless start_date > end_date

    errors.add(:start_date, 'Please Check Start Date')
  end

  def start_date_validation
    return unless start_date < Time.now.getlocal

    errors.add(:start_date, 'Please Check Start Date')
  end
end
