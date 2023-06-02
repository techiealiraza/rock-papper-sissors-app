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
    try_num = job.arguments[1] - 1
    match = Match.find(job.arguments[0])
    sleep 3
    match.handle_missing_selections(try_num)
    UpdateWinner.new(match, try_num).update_winner
    user1_id, user2_id = match.users.ids
    selection1, selection2 = match.selections.by_try_num(try_num).group_by(&:user_id).values_at(user1_id, user2_id)
    selection1 = selection1.first
    selection2 = selection2.first
    status = selection1.status || selection2.status || 'Draw'
    broadcast(match.id, user1_id, user2_id, status, [selection1, selection2])
    sleep(0.5)
    user1_winning_selections, user2_winning_selections = match.selections.winner.group_by(&:user_id).values_at(
      user1_id, user2_id
    )
    score1 = score(user1_winning_selections)
    score2 = score(user2_winning_selections)
    try_num += 1
    monitor_tries(match, try_num, score1, score2, [selection1, selection2])
  end

  def score(selections)
    if selections.nil?
      0
    else
      selections.size
    end
  end

  def monitor_tries(match, try_num, score1, score2, selections)
    user1_id, user2_id = match.users.ids
    if try_num < 3 || try_num == 4
      match.delayed_job(Time.zone.now + 5.seconds, try_num + 1)
    elsif score1 == score2
      handle_equal_scores(match, try_num, selections)
    elsif [3, 5].include?(try_num)
      winner_id = score1 > score2 ? user1_id : user2_id
      match.update(match_winner_id: winner_id)
      broadcast(match.id, user1_id, user2_id, "#{match.winner.name} won", selections)
      sleep 2
      generate_matches(match, selections)
    end
  end

  def handle_equal_scores(match, try_num, selections)
    user1_id, user2_id = match.users.ids
    if try_num == 3
      add_tries_and_broadcast(match, try_num, selections)
    elsif try_num == 5
      broadcast(match.id, user1_id, user2_id, 'Random Picking', selections)
      sleep 2
      match.update(match_winner_id: [user1_id, user2_id].sample)
      broadcast(match.id, user1_id, user2_id, "#{match.winner.name} won", selections)
      generate_matches(match, selections)
    end
  end

  def add_tries_and_broadcast(match, try_num, selections)
    user1_id, user2_id = match.users.ids
    match.update(tries: 5)
    broadcast(match.id, user1_id, user2_id, '2 tries added', selections)
    sleep 2
    MatchBroadcastJob.perform_later(match.id, try_num + 1, 5)
  end

  def broadcast(match_id, user1_id, user2_id, status, selections)
    ActionCable.server.broadcast("timer_channel_#{match_id}",
                                 { user1_id:, user2_id:, status:,
                                   selection1: selections.first.selection,
                                   selection2: selections.last.selection })
  end

  def generate_matches(match, selections)
    user1_id, user2_id = match.users.ids
    tournament = match.tournament
    current_round_remaining_matches = tournament.remaining_matches_by_round_size(match.round)
    done_matches_size = tournament.done_matches_size(match.round)
    matches_by_round_size = tournament.matches_by_round_size(match.round)
    if done_matches_size == 1 && matches_by_round_size == 1
      tournament.update_column(:tournament_winner_id, match.match_winner_id)
      broadcast(match.id, user1_id, user2_id, "Tournament Winner is #{tournament.winner.name}", selections)
    elsif current_round_remaining_matches.zero?
      tournament.create_matches(match)
    end
  end
end
