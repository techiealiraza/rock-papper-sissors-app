# frozen_string_literal: true

# broad_cast_service
class Broadcaster
  def initialize(channel, data)
    @channel = channel
    @data = data
  end

  def call
    ActionCable.server.broadcast(@channel, @data)
  end
end
