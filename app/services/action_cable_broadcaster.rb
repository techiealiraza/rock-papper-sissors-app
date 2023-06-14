# frozen_string_literal: true

# broad_cast_to_a_channel_service
class ActionCableBroadcaster
  def initialize(channel, data)
    @channel = channel
    @data = data
  end

  def call
    ActionCable.server.broadcast(@channel, @data)
  end
end
