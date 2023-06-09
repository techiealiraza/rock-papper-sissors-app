# frozen_string_literal: true

# channel for timer and selection
class PlayMatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "play_match_channel_#{params[:match_id]}"
  end
end
