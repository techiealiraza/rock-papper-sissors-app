# frozen_string_literal: true

class MatchProgressionHandler
  def initialize(match, try_num, score1, score2, selections)
    @match = match
    @try_num = try_num
    @score1 = score1
    @score2 = score2
    @selections = selections
  end

  def call
    case @try_num
    when 1, 2, 4
      schedule_next_try
    when 3, 5
      if @score1 == @score2
        handle_equal_scores
      else
        update_winner_and_broadcast_status
      end
    end
  end

  private

  def schedule_next_try
    @match.schedule(Time.zone.now, @try_num + 1)
  end

  def handle_equal_scores
    if @try_num == 3
      handle_equal_scores_three
    elsif @try_num == 5
      handle_equal_scores_five
    end
  end

  def handle_equal_scores_three
    add_tries_and_broadcast
    schedule_next_try
  end

  def handle_equal_scores_five
    broadcast_selections_result('Random Picking')
    @match.update_random_winner
    broadcast_selections_result("Match Winner is #{@match.winner.name}")
    generate_matches
  end

  def add_tries_and_broadcast
    @match.update(tries: 5)
    broadcast_selections_result('2 Tries Added')
  end

  def broadcast_selections_result(status)
    SelectionResultBroadcaster.new(status, @selections).call
    sleep 1
  end

  def generate_matches
    tournament = @match.tournament
    tournament.generate_matches_or_update_winner(@match)
  end

  def update_winner_and_broadcast_status
    @match.update_winner_on_scores
    broadcast_selections_result("Match Winner is #{@match.winner.name}")
  end
end
