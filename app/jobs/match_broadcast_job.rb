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
    sleep(2)
    user1_selections = match.user_selections(user1_id)
    user2_selections = match.user_selections(user2_id)
    selection1 = match.user_selections(user1_id).last
    selection2 = match.user_selections(user2_id).last
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
    sleep(0.5)
    score1 = match.user_selections(user1_id).winner.size
    score2 = match.user_selections(user2_id).winner.size
    if try_num == 3 && score1 == score2
      match.tries = 4
      match.save
      ActionCable.server.broadcast("timer_channel_#{job.arguments[0]}",
        { id1: user1_id, id2: user2_id, status1: '1 Try Added', selection1: selection1.selection,
          selection2: selection2.selection, status2: '1 Try Added' })
      sleep(2)
      MatchBroadcastJob.perform_later(match.id, try_num+1, 4)
    elsif try_num == 4 && score1 == score2
      sleep 2
      ActionCable.server.broadcast("timer_channel_#{job.arguments[0]}",
        { id1: user1_id, id2: user2_id, status1: 'Picking Random Winner', selection1: selection1.selection,
          selection2: selection2.selection, status2: 'Picking Random Winner' })
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
    next_match_time = match.match_time + 10.seconds
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
      tournament.tournament_winner_id = match.match_winner_id
      tournament.save
    # create_matches(tournament.current_round_winners(match.round), tournament)
    elsif done_matches_count == matches_count_by_round && done_matches_count > 1
      create_matches(tournament.current_round_winners(match.round), tournament, next_match_time, next_match_round)
    end
      
  end

  def create_matches(users, tournament, next_match_time, next_match_round)
    puts users
    matches = []
    registered_users = users.shuffle
    length = registered_users.length
    matches = group_by_two(registered_users, tournament, next_match_time, next_match_round)
    Match.transaction do
      matches.each(&:save!)
    end
  end

  def match_broadcast_job(run_at, match_id, try_num, tries)
    3.times do
      MatchBroadcastJob.delay(run_at:).perform_later(match_id, try_num, tries)
      run_at += 8.seconds
      try_num += 1
    end
  end

  def group_by_two(registered_users, tournament, next_match_time, next_match_round)
    matches = []
    registered_users.each_slice(2) do |user1, user2|
      match = Match.create(tournament_id: tournament.id, match_time: next_match_time, round: next_match_round)
      match_broadcast_job(next_match_time - 5.hours + 5.seconds, match.id, 1, match.tries)
      matches << user_match_obj(match, user1)
      matches << user_match_obj(match, user2)
    end
    matches
  end

  def user_match_obj(match, user)
    UsersMatch.new(match:, user:)
  end

  def set_random_choices(user, match_id, try_num)
    # choices = %w[paper rock scissor rock scissor paper]
    choices = %w[paper paper paper paper paper paper]
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
