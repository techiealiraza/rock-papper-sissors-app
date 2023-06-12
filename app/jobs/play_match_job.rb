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
    SelectionResultBroadcaster.new(status, [selection1, selection2]).call
    sleep 1
    score1, score2 = match.scores
    MatchProgressionHandler.new(match, try_num, score1, score2, [selection1, selection2]).call
  end
end
