class Tournament < ApplicationRecord
  paginates_per 3
  has_many :tournaments_users
  has_many :users, through: :tournaments_users
  has_many :matches, dependent: :destroy
  has_one_attached :image
  validates :name, :description, :start_date, :end_date, :registration_deadline, presence: true
  validate :end_date_is_after_start_date
  validate :start_date_is_after_end_date
  validate :start_date_validation
  validate :deadline_before_start_date

  def deadline_before_start_date
    return if registration_deadline.nil? || start_date.nil?
    return unless registration_deadline > start_date || registration_deadline < Time.now.getlocal

    errors.add(:registration_deadline, ':Please Check Registration Deadline')
  end

  def end_date_is_after_start_date
    return if end_date.nil? || start_date.nil?
    return unless end_date < start_date

    errors.add(:end_date, 'Please Check End Date')
  end

  def start_date_is_after_end_date
    return if end_date.nil? || start_date.nil?
    return unless start_date > end_date

    errors.add(:start_date, 'Please Check Start Date')
  end

  def start_date_validation
    return if start_date.nil?
    return unless start_date < Time.now.getlocal

    errors.add(:start_date, 'Please Check Start Date')
  end
end
