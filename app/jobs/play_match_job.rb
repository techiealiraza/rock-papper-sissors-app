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
    selection1, selection2 = match.selections.by_try_num(try_num)
    status = selection1.status || selection2.status || 'Draw Try'
    broadcast_selections_result(status, [selection1, selection2])
    score1, score2 = match.scores
    handle_match_progression(match, try_num, score1, score2, [selection1, selection2])
  end

  def handle_match_progression(match, try_num, score1, score2, selections)
    if [1, 2, 4].include?(try_num)
      match.schedule(Time.zone.now, try_num + 1)
    elsif score1 == score2
      handle_equal_scores(match, try_num, selections)
    elsif [3, 5].include?(try_num)
      match.update_winner_on_scores
      broadcast_selections_result("Match Winner is #{match.winner.name}", selections)
      generate_matches(match)
    end
  end

  def handle_equal_scores(match, try_num, selections)
    if try_num == 3
      add_tries_and_broadcast(match, try_num, selections)
    elsif try_num == 5
      broadcast_selections_result('Random Picking', selections)
      match.update_random_winner
      broadcast_selections_result("Match Winner is #{match.winner.name}", selections)
      generate_matches(match)
    end
  end

  def add_tries_and_broadcast(match, try_num, selections)
    match.update(tries: 5)
    broadcast_selections_result('2 tries added', selections)
    match.schedule(Time.zone.now, try_num + 1)
  end

  def broadcast_selections_result(status, selections)
    SelectionResultBroadcaster.new(status, selections).call
    sleep 1
  end

  def generate_matches(match)
    tournament = match.tournament
    tournament.generate_matches_or_update_winner(match)
  end
end
