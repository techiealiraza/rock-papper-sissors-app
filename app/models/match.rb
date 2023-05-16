# frozen_string_literal: true

# Match Model
class Match < ApplicationRecord
  paginates_per 5
  belongs_to :tournament
  has_many :messages
  has_many :users_matches
  has_many :users, through: :users_matches
  has_many :selections
  scope :desc, -> { order(round: :desc) }

  def opponent_user_id(current_user_id)
    users_matches.find_by(match_id: id, user: User.where.not(id: current_user_id)).user_id
  end

  def user_selections(user)
    selections.where(user:)
  end

  def done_tries_num(user)
    selections.where(user:).size
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
      "#{users.find(match_winner_id).name} won"
    end
  end

  def delayed_job(try_num = 1)
    if try_num == 1
      MatchBroadcastJob.delay(run_at: match_time.utc + 10.seconds).perform_later(id, try_num, tries)
    else
      MatchBroadcastJob.delay(run_at: 2.seconds.from_now).perform_later(id, try_num, tries)
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

  def user_selection_by(user, try_num)
    selections.find_by(user:, try_num:)
  end

  def last_selections(size1, size2, try_num)
    if size1 == size2 && size2 == try_num - 1
      random_selections(users.first.id, users.last.id, try_num)
    elsif size1 < size2
      [set_random_choices(users.first.id, try_num),
       user_selection_by(users.last.id, try_num - 1)]
    elsif size2 < size1
      [user_selection_by(users.first.id, try_num - 1),
       set_random_choices(users.last.id, try_num)]
    else
      both_player_selection(try_num)
    end
  end

  def both_player_selection(try_num)
    [user_selection_by(users.first.id, try_num - 1),
     user_selection_by(users.last.id, try_num - 1)]
  end

  def random_selections(user1_id, user2_id, try_num)
    [set_random_choices(user1_id, try_num), set_random_choices(user2_id, try_num)]
  end

  def selections_data(try_num)
    sleep(3)
    selections_data = calculate_selections_data(try_num)
    update_winner(selections_data.first, selections_data.last)
    [users.first.id, users.last.id, status(selections_data), selections_data.first, selections_data.last]
  end

  def status(selections_data)
    selections_data.first.status || selections_data.last.status || 'Draw'
  end

  def calculate_selections_data(try_num)
    user1_selections = user_selections(users.first.id)
    user2_selections = user_selections(users.last.id)
    last_selections(user1_selections.size, user2_selections.size, try_num)
  end

  def update_winner(selection1, selection2)
    choice1 = selection1.selection
    choice2 = selection2.selection
    return if choice1 == choice2

    if (choice1 == 'rock' && choice2 == 'scissor') ||
       (choice1 == 'scissor' && choice2 == 'paper') ||
       (choice1 == 'paper' && choice2 == 'rock')
      selection1.update_winner
    else
      selection2.update_winner
    end
  end
end
