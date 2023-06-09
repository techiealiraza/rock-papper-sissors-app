# frozen_string_literal: true

# message_broadcast_service
class MessageBroadcaster < Broadcaster
  def initialize(message)
    super("room_channel_#{message.match_id}", {
      message: message.content,
      sender_name: message.name,
      user_id: message.user_id,
      created_at: message.created_at.strftime('%H:%M:%S')
    })
  end
end
