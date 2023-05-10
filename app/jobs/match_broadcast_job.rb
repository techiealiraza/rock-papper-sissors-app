# frozen_string_literal: true

# Match_Broadcast_Job
class MatchBroadcastJob < ApplicationJob
  queue_as :default

  def perform(match_id, try_num, tries)
    5.downto(0) do |seconds|
      ActionCable.server.broadcast("timer_channel_#{match_id}", { seconds:, try_num:, tries: })
      sleep 1
    end
  end

  after_perform do |job|
    match = Match.find(job.arguments[0])
    match_users = match.users
    try_num = job.arguments[1]
    user1_id = match_users[0].id
    user2_id = match_users[1].id
    sleep(1)
    user1_selections = match.user_selections(user1_id)
    user2_selections = match.user_selections(user2_id)
    size1 = user1_selections.size
    size2 = user2_selections.size

    if size1 == size2 && size2 == try_num - 1
      selection1 = set_random_choices(user1_id, match.id, try_num)
      selection2 = set_random_choices(user2_id, match.id, try_num)

    elsif size1 < size2
      selection1 = set_random_choices(user1_id, match.id, try_num)
      selection2 = match.user_selections(user2_id).last
    elsif size2 < size1
      selection1 = match.user_selections(user1_id).last
      selection2 = set_random_choices(user2_id, match.id, try_num)
    end
    update_winner(selection1, selection2)
    status1 = selection1.status
    status2 = selection2.status
    ActionCable.server.broadcast("timer_channel_#{job.arguments[0]}",
                                 { id1: user1_id, id2: user2_id, status1:, selection1: selection1.selection,
                                   selection2: selection2.selection, status2: })
  end

  def set_random_choices(user, match_id, try_num)
    choices = %w[paper rock scissor rock scissor paper]
    random_choice = rand 0..5
    choice = choices[random_choice]
    selection = Selection.new(match_id:, user:, selection: choice, try_num: try_num - 1)
    selection.save
    selection
  end

  def update_winner(selection1, selection2)
    choice1 = selection1.selection
    choice2 = selection2.selection
    return if choice1 == choice2

    if (choice1 == 'rock' && choice2 == 'scissor') ||
       (choice1 == 'scissor' && choice2 == 'paper') ||
       (choice1 == 'paper' && choice2 == 'rock')
      selection1.update_winner
      selection1.save
    else
      selection2.update_winner
      selection2.save
    end
  end
end
