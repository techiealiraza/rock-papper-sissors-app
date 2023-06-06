# frozen_string_literal: true

# broad_cast_message_service
class BroadcastMessage
  def self.call(channel, data)
    ActionCable.server.broadcast(channel, data)
  end
end
