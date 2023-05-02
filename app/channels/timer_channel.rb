class TimerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "timer_channel_#{params[:match_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
