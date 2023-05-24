# frozen_string_literal: true

# channel for messages
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:match_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
