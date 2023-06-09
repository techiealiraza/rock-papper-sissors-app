# frozen_string_literal: true

# selection_time_broadcast_service
class SelectionCountdownBroadcaster < Broadcaster
  def initialize(match_id, seconds, try_num, tries)
    super("play_match_channel_#{match_id}", {
      seconds:,
      try_num:,
      tries:
    })
  end
end
