# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  delegate :name, to: :user, allow_nil: true
  after_save :broadcast

  def broadcast
    BroadcastMessage.call(message, name, created_at.strftime('%H:%M:%S'), match_id)
  end
end
