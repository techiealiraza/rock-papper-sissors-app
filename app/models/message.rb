# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  delegate :name, to: :user, allow_nil: true
  after_save :broadcast

  def broadcast
    MessageBroadcaster.new(self).call
  end
end
