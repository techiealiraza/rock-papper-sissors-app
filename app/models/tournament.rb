# frozen_string_literal: true

class Tournament < ApplicationRecord
  paginates_per 3
  include ImageValidatable
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
  scope :won, ->(user_id) { where(winner_id: user_id) }
  scope :desc, -> { order(registration_deadline: :desc) }

  def deadline_before_start_date
    return if registration_deadline.nil? || start_date.nil?
    return if registration_deadline < start_date && registration_deadline > Time.zone.now

    errors.add(:registration_deadline, ':Please Check Registration Deadline')
  end

  def end_date_is_after_start_date
    return if end_date.nil? || start_date.nil?
    return unless end_date < start_date

    errors.add(:end_date, ':End Date is before Start Date')
  end

  def start_date_validation
    return if start_date.nil?
    return unless start_date < Time.zone.now

    errors.add(:start_date, 'Start Date is in Past')
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

  def create_matches(round)
    TournamentMatchesCreator.new(self, current_round_winners(round),
                                 round + 1).call
  end

  def done_matches_count_by_round(round)
    matches.by_round(round).done.count
  end

  def matches_count_by_round(round)
    matches.by_round(round).count
  end

  def create_next_round_matches?
    pending_matches_count.zero?
  end

  def pending_matches_count
    matches.undone.count
  end

  def final_match_done?(round)
    current_round_done_matches_count = done_matches_count_by_round(round)
    current_round_matches_count = matches_count_by_round(round)
    current_round_done_matches_count == 1 && current_round_matches_count == 1
  end

  def generate_matches_or_update_winner(match)
    if final_match_done?(match.round)
      update_column(:winner_id, match.winner_id)
    elsif create_next_round_matches?
      create_matches(match.round)
    end
  end
end
