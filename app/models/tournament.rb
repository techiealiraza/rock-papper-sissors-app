# frozen_string_literal: true

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

    errors.add(:registration_deadline, 'Registration Deadline is after Start Date')
  end

  def end_date_is_after_start_date
    return if end_date.nil? || start_date.nil?
    return unless end_date < start_date

    errors.add(:end_date, 'End Date is before Start Date')
  end

  def start_date_is_after_end_date
    return if end_date.nil? || start_date.nil?
    return unless start_date > end_date

    errors.add(:start_date, 'Start Date is after End Date')
  end

  def start_date_validation
    return if start_date.nil?
    return unless start_date < Time.now.getlocal

    errors.add(:start_date, 'Start Date is in Past')
  end

  def match_winners_count(round)
    matches.where.not(match_winner_id: nil).where(round: round)
  end

  def matches_by_round(round)
    matches.where(round: round)
  end

  def current_round_winners(round)
    ids = matches.where.not(match_winner_id: nil).where(round: round).pluck(:match_winner_id)
    User.where(id: ids)
  end

end
