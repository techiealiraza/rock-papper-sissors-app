# frozen_string_literal: true

class Match < ApplicationRecord
  paginates_per 3
  belongs_to :tournament
  has_many :messages
  has_many :users_matches
  has_many :users, through: :users_matches
  has_many :selections

  def started?
    start_time < Time.now
  end

  def opponent_user_id(current_user_id)
    UsersMatch.where(match_id: id).where.not(user_id: current_user_id).pluck(:user_id).first
  end

  def user_selections(user_id)
    Selection.where(match_id: id, user: user_id)
  end

  def user_selection_by(user, try_num)
    Selection.where(match_id: id, user:, try_num:).first
  end

  def done_tries_num(user)
    Selection.where(match_id: id, user:).size
  end

  def remaining_tries(user)
    done_tries = done_tries_num(user)
    if done_tries
      tries - done_tries
    else
      tries
    end
  end

  def result_message(current_user_id)
    if match_winner_id == current_user_id
      'You Won'
    else
      "#{User.find(match_winner_id).name} won"
    end
  end

  def delayed_job(try_num = 1)
    if try_num == 1
      run_at = match_time - 5.hours + 20.seconds
      3.times do
        MatchBroadcastJob.delay(run_at:).perform_later(id, try_num, tries)
        run_at += 9.seconds
        try_num += 1
      end
    else
      MatchBroadcastJob.delay(run_at:).perform_later(id, try_num, tries)
    end
  end

  def set_random_choices(user, try_num)
    # choices = %w[paper rock scissor rock scissor paper]
    choices = %w[paper paper paper paper paper paper]
    random_choice = rand 0..5
    choice = choices[random_choice]
    selection = Selection.new(match_id: id, user:, selection: choice, try_num: try_num - 1)
    selection.save
    selection
  end

  def last_selections(size1, size2, try_num)
    user1_id = users.first.id
    user2_id = users.last.id
    if size1 == size2 && size2 == try_num - 1
      random_selections(user1_id, user2_id, try_num)
    elsif size1 < size2
      [set_random_choices(user1_id, try_num), user_selection_by(user2_id, try_num - 1)]
    elsif size2 < size1
      [user_selection_by(user1_id, try_num - 1), set_random_choices(user2_id, try_num)]
    end
  end

  def random_selections(user1_id, user2_id, try_num)
    [set_random_choices(user1_id, try_num), set_random_choices(user2_id, try_num)]
  end
end
