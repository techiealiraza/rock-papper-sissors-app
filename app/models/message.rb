# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  delegate :name, to: :user, allow_nil: true
  after_save :broadcast

  def broadcast
    payload = {
      message:,
      user_name: name,
      created_at: created_at.strftime('%H:%M:%S')
    }
    ActionCable.server.broadcast("room_channel_#{match_id}", payload)
  end
end
