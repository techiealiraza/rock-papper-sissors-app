# frozen_string_literal: true

# channel for timer and selection
class TimerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "timer_channel_#{params[:match_id]}"
  end
end
