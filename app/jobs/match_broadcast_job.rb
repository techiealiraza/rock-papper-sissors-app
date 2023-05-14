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
    sleep(3)
    user1_selections = match.user_selections(user1_id)
    user2_selections = match.user_selections(user2_id)
    size1 = user1_selections.size
    size2 = user2_selections.size
    selections_data = match.last_selections(size1, size2, try_num)
    selection1 = selections_data[0]
    selection2 = selections_data[1]
    update_winner(selection1, selection2)
    status = selection1.status || selection2.status || 'Draw'
    ActionCable.server.broadcast("timer_channel_#{job.arguments[0]}",
                                 { id1: user1_id, id2: user2_id, status1: status, selection1: selection1.selection,
                                   selection2: selection2.selection, status2: status })
    sleep(0.5)
    score1 = match.user_selections(user1_id).winner.size
    score2 = match.user_selections(user2_id).winner.size
    if try_num == 3 && score1 == score2
      match.update(tries: 4)
      ActionCable.server.broadcast("timer_channel_#{job.arguments[0]}",
                                   { id1: user1_id, id2: user2_id, status1: '1 Try Added', selection1: selection1.selection,
                                     selection2: selection2.selection, status2: '1 Try Added' })
      sleep(2)
      MatchBroadcastJob.perform_later(match.id, try_num + 1, 4)
    elsif try_num == 4 && score1 == score2
      sleep 2
      ActionCable.server.broadcast("timer_channel_#{job.arguments[0]}",
                                   { id1: user1_id, id2: user2_id, status1: 'Picking Random Winner',
                                     selection1: selection1.selection,
                                     selection2: selection2.selection,
                                     status2: 'Picking Random Winner' })
      match.match_winner_id = pick_random(user1_id, user2_id)
      match.save
      generate_matches(match)
    elsif try_num >= 3 && score1 > score2
      match.match_winner_id = user1_id
      match.save
      generate_matches(match)
    elsif try_num >= 3 && score2 > score1
      match.match_winner_id = user2_id
      match.save
      generate_matches(match)
    end
  end

  def pick_random(id1, id2)
    ids = [id1, id2]
    random_id = rand 0..1
    ids[random_id]
  end

  def generate_matches(match)
    next_match_round = match.round + 1
    tournament = match.tournament
    done_matches_count = tournament.match_winners_count(match.round).size
    matches_count_by_round = tournament.matches_by_round(match.round).size
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    puts done_matches_count
    puts matches_count_by_round
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    if done_matches_count == matches_count_by_round && matches_count_by_round == 1
      tournament.update_winner(match.match_winner_id)
    elsif done_matches_count == matches_count_by_round && done_matches_count > 1
      matches = MatchCreator.new(tournament, tournament.current_round_winners(match.round),
                                 next_match_round).create_match
      matches.each(&:delayed_job)
    end
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
