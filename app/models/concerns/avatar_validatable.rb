# frozen_literal_string: true
# app/models/concerns/avatar_validatable.rb
module AvatarValidatable
  extend ActiveSupport::Concern

  included do
    validate :validate_avatar_type
    validate :validate_avatar_size
  end

  private

  def validate_avatar_type
    return unless avatar.attached? && !avatar.content_type.in?(%w[avatar/jpeg avatar/png])

    errors.add(:avatar, 'must be a JPEG or PNG')
  end

  def validate_avatar_size
    return unless avatar.attached? && avatar.byte_size > 5.megabytes

    errors.add(:avatar, 'size should be less than 5MB')
  end
end
