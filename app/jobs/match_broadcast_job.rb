class MatchBroadcastJob < ApplicationJob
  queue_as :default
  def perform(match_id)
    seconds = 5
    while seconds.positive?
      ActionCable.server.broadcast("timer_channel_#{match_id}", seconds)
      seconds -= 1
      sleep 1
    end
    ActionCable.server.broadcast("timer_channel_#{match_id}", 'Stop')
  end

  # def random_image(match_id)
  #   images = (['/assets/rock'] * 3 + ['/assets/paper'] * 3 + ['/assets/scissor'] * 3).shuffle
  #   seconds = 5
  #   while seconds.positive?
  #     index = rand(9)
  #     image = images[index]
  #     ActionCable.server.broadcast("random_channel_#{match_id}", image)
  #     seconds -= 0.3
  #     sleep(0.3)
  #   end
  # end
end
