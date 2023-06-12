# frozen_string_literal: true

# channel for timer and selection
class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "match_channel_#{params[:match_id]}"
  end
end
