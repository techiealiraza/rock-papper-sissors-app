# frozen_string_literal: true

class PlayMatchJob < ApplicationJob
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
    match.handle_missing_selections(try_num)
    SelectionUpdateWinner.new(match, try_num).call
    user1_id, user2_id = match.users.ids
    selection1, selection2 = match.selections.by_try_num(try_num).group_by(&:user_id).values_at(user1_id, user2_id)
    selection1 = selection1.first
    selection2 = selection2.first
    status = selection1.status || selection2.status || 'Draw'
    broadcast(match.id, user1_id, user2_id, status, [selection1, selection2])
    user1_winning_selections, user2_winning_selections = match.selections.winner.group_by(&:user_id).values_at(
      user1_id, user2_id
    )
    score1 = score(user1_winning_selections)
    score2 = score(user2_winning_selections)
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
      match.schedule(Time.zone.now, try_num + 1)
    elsif score1 == score2
      handle_equal_scores(match, try_num, selections)
    elsif [3, 5].include?(try_num)
      winner_id = score1 > score2 ? user1_id : user2_id
      match.update(winner_id:)
      broadcast(match.id, user1_id, user2_id, "Match Winner is #{match.winner.name}", selections)
      generate_matches(match)
    end
  end

  def handle_equal_scores(match, try_num, selections)
    user1_id, user2_id = match.users.ids
    if try_num == 3
      add_tries_and_broadcast(match, try_num, selections)
    elsif try_num == 5
      broadcast(match.id, user1_id, user2_id, 'Random Picking', selections)
      match.update(winner_id: [user1_id, user2_id].sample)
      broadcast(match.id, user1_id, user2_id, "Match Winner is #{match.winner.name}", selections)
      generate_matches(match)
    end
  end

  def add_tries_and_broadcast(match, try_num, selections)
    user1_id, user2_id = match.users.ids
    match.update(tries: 5)
    broadcast(match.id, user1_id, user2_id, '2 tries added', selections)
    PlayMatchJob.perform_later(match.id, try_num + 1, match.tries)
  end

  def broadcast(match_id, user1_id, user2_id, status, selections)
    data = data_for_broadcast(user1_id, user2_id, status, selections)
    Broadcaster.call("timer_channel_#{match_id}", data)
    sleep 1
  end

  def data_for_broadcast(user1_id, user2_id, status, selections)
    choice1, choice2 = selections.pluck(:choice).first(2)
    data = { user1_id:, user2_id:, status:, selection1: choice1, selection2: choice2 }
    data.merge!(done: true) if selections.first.match.done?
    data
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
