# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match

  def user_name
    User.where(id: user_id).first.name
  end
end
