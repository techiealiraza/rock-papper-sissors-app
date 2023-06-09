# frozen_string_literal: true

class PlayMatchJob < ApplicationJob
  queue_as :default

  def perform(match_id, try_num, tries)
    5.downto(0) do |seconds|
      SelectionCountdownBroadcaster.new(match_id, seconds, try_num, tries).call
      sleep 1
    end
  end

  after_perform do |job|
    try_num = job.arguments[1]
    match = Match.find(job.arguments[0])
    match.handle_missing_selections(try_num)
    SelectionUpdateWinner.new(match, try_num).call
    user1_id, user2_id = match.users.ids
    current_try_selections = match.selections.by_try_num(try_num).group_by(&:user_id)
    selection1, selection2 = current_try_selections.values_at(user1_id, user2_id)
    selection1 = selection1.first
    selection2 = selection2.first
    status = selection1.status || selection2.status || 'Draw Try'
    broadcast(status, [selection1, selection2])
    score1, score2 = match.scores
    handle_match_progression(match, try_num, score1, score2, [selection1, selection2])
  end

  def handle_match_progression(match, try_num, score1, score2, selections)
    if try_num < 3 || try_num == 4
      match.schedule(Time.zone.now, try_num + 1)
    elsif score1 == score2
      handle_equal_scores(match, try_num, selections)
    elsif [3, 5].include?(try_num)
      match.update_winner_on_scores
      broadcast("Match Winner is #{match.winner.name}", selections)
      generate_matches(match)
    end
  end

  def handle_equal_scores(match, try_num, selections)
    if try_num == 3
      add_tries_and_broadcast(match, try_num, selections)
    elsif try_num == 5
      broadcast('Random Picking', selections)
      match.update_random_winner
      broadcast("Match Winner is #{match.winner.name}", selections)
      generate_matches(match)
    end
  end

  def add_tries_and_broadcast(match, try_num, selections)
    match.update(tries: 5)
    broadcast('2 tries added', selections)
    PlayMatchJob.perform_later(match.id, try_num + 1, match.tries)
  end

  def broadcast(status, selections)
    SelectionResultBroadcaster.new(status, selections).call
    sleep 1
  end

  def generate_matches(match)
    tournament = match.tournament
    current_round_pending_matches_count = tournament.matches.un_done.count
    current_round_done_matches_count = tournament.matches.by_round(match.round).done.count
    current_round_matches_count = tournament.matches.by_round(match.round).count
    if current_round_done_matches_count == 1 && current_round_matches_count == 1
      tournament.update_column(:winner_id, match.winner_id)
    elsif current_round_pending_matches_count.zero?
      tournament.create_matches(match)
    end
  end
end
