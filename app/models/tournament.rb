# frozen_string_literal: true

# Tournaments:: controller
class Tournament < ApplicationRecord
  paginates_per 3
  has_many :tournaments_users
  has_many :users
  has_many :users, through: :tournaments_users
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id', optional: true
  has_many :matches, dependent: :destroy
  has_one_attached :image
  validates :name, :description, :start_date, :end_date, :registration_deadline, presence: true
  validate :end_date_is_after_start_date
  validate :start_date_validation
  validate :deadline_before_start_date

  def deadline_before_start_date
    return if registration_deadline.nil? || start_date.nil?
    return unless registration_deadline > start_date || registration_deadline < Time.zone.now

    errors.add(:registration_deadline, 'Registration Deadline is after Start Date')
  end

  def end_date_is_after_start_date
    return if end_date.nil? || start_date.nil?
    return unless end_date < start_date

    errors.add(:end_date, 'End Date is before Start Date')
  end

  def start_date_validation
    return if start_date.nil?
    return unless start_date < Time.zone.now

    errors.add(:start_date, 'Start Date is in Past')
  end

  def done_matches_size(round)
    matches.by_round(round).where.not(winner_id: nil).size
  end

  def remaining_matches_by_round_size(round)
    matches.by_round(round).where(winner_id: nil).size
  end

  def matches_by_round_size(round)
    matches.by_round(round).size
  end

  def current_round_winners(round)
    users.where(id: matches.select(:winner_id).by_round(round))
  end

  def current_match_time
    if matches.empty?
      start_date + 60.seconds
    else
      Time.zone.now + 90.seconds
    end
  end

  def create_matches(match)
    MatchCreator.new(self, current_round_winners(match.round),
                     match.round + 1).call
  end
end
