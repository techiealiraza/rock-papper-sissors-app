# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  delegate :name, to: :user, allow_nil: true
  after_save :broadcast

  def broadcast
    data = { message: content, user_name: name, created_at: created_at.strftime('%H:%M:%S') }
    Broadcaster.call("room_channel_#{match_id}", data)
  end
end
