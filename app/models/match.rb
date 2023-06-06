# frozen_string_literal: true

# Match Model
class Match < ApplicationRecord
  paginates_per 5
  belongs_to :tournament
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id', optional: true
  has_many :messages
  has_many :users_matches
  has_many :users, through: :users_matches
  has_many :selections
  scope :desc, -> { order(round: :desc) }
  scope :by_round, ->(round) { where(round:) }
  scope :done, -> { where.not(winner_id: nil) }
  scope :winner_count, ->(user_id) { where(winner_id: user_id).size }
  scope :tournament_count, ->(id) { distinct.count(tournament_id: id) }
  CHOICES = %w[rock paper scissor].freeze
  after_create :schedule

  def remaining_tries
    done_tries = selections.by_user(users.first.id).size
    tries - done_tries
  end

  def result_message(current_user_id)
    if winner_id == current_user_id
      'You Won'
    else
      "#{winner&.name} won"
    end
  end

  def schedule(run_at = time + 10.seconds, try_num = 1)
    MatchBroadcastJob.delay(run_at:).perform_later(id, try_num, tries)
  end

  def set_random_choices(user_id, try_num)
    selections.create(user_id:, choice: CHOICES.sample, try_num:)
  end

  def handle_missing_selections(try_num)
    players_selections = selections.by_try_num(try_num)
    first_user_id, second_user_id = users.ids
    set_random_choices(first_user_id, try_num) unless players_selections.exists?(user_id: first_user_id)
    return if players_selections.exists?(user_id: second_user_id)

    set_random_choices(second_user_id, try_num)
  end

  def user_names_and_ids
    users.names_and_ids
  end
end
