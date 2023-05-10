# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    # byebug
    stream_from "room_channel_#{params[:match_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
