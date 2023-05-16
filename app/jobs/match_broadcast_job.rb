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
    try_num = job.arguments[1]
    match = Match.find(job.arguments[0])
    data = match.selections_data(try_num)
    user1_id = data[0]
    user2_id = data[1]
    status = data[2]
    selection1 = data[3]
    selection2 = data[4]
    broadcast(match.id, user1_id, user2_id, status, [selection1, selection2])
    sleep(0.5)
    score1 = match.user_selections(user1_id).winner.size
    score2 = match.user_selections(user2_id).winner.size
    if try_num == 3 && score1 == score2
      match.update(tries: 4)
      broadcast(match.id, user1_id, user2_id, '1 try added', [selection1, selection2])
      sleep(2)
      MatchBroadcastJob.perform_later(match.id, try_num + 1, 4)
    elsif try_num == 4 && score1 == score2
      sleep 2
      broadcast(match.id, user1_id, user2_id, 'Random Picking', [selection1, selection2])
      match.update(match_winner_id: pick_random(user1_id, user2_id))
      broadcast(match.id, user1_id, user2_id, 'Random Picking', [selection1, selection2])
      generate_matches(match)
    elsif try_num >= 3 && score1 > score2
      match.update(match_winner_id: user1_id)
      generate_matches(match)
    elsif try_num >= 3 && score2 > score1
      match.update(match_winner_id: user2_id)
      generate_matches(match)
    elsif try_num < 3
      match.delayed_job(try_num + 1)
    end
  end

  def pick_random(id1, id2)
    ids = [id1, id2]
    random_id = rand 0..1
    ids[random_id]
  end

  def broadcast(match_id, id1, id2, status, selections)
    ActionCable.server.broadcast("timer_channel_#{match_id}",
                                 { id1:, id2:, status1: status,
                                   selection1: selections.first.selection,
                                   selection2: selections.last.selection,
                                   status2: status })
  end

  def generate_matches(match)
    next_match_round = match.round + 1
    tournament = match.tournament
    done_matches_count = tournament.match_winners_count(match.round).size
    matches_count_by_round = tournament.matches_by_round(match.round).size
    if done_matches_count == matches_count_by_round && matches_count_by_round == 1
      tournament.update_winner(match.match_winner_id)
    elsif done_matches_count == matches_count_by_round && done_matches_count > 1
      MatchCreator.new(tournament, tournament.current_round_winners(match.round),
                       next_match_round).create_match
    end
  end
end
