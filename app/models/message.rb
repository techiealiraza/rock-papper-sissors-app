# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  delegate :name, to: :user, allow_nil: true
end
