# broad_cast_message_service
class BroadcastMessage
  def self.send(message, user_name, created_at, match_id)
    data = {
      message:,
      user_name:,
      created_at:
    }
    ActionCable.server.broadcast("room_channel_#{match_id}", data)
  end
end
