# app/models/concerns/image_validatable.rb
module ImageValidatable
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validate :validate_image_attachment, on: %i[create update], unless: :skip_validation?
  end
  attr_accessor :controller_context

  def skip_validation?
    return true if controller_context&.controller_name == 'registrations' && controller_context&.action_name == 'create'

    false
  end

  def validate_image_attachment
    attachment = send(attachment_attribute)

    if attachment.present?
      validate_image_content_type(attachment)
      validate_image_size(attachment)
    else
      errors.add(attachment_attribute, 'must be attached')
    end
  end

  def validate_image_content_type(attachment)
    return unless attachment.content_type.present?
    return if attachment.content_type.in?(%w[image/jpeg image/png])

    errors.add(attachment_attribute, 'must be a JPEG or PNG')
  end

  def validate_image_size(attachment)
    return unless attachment.byte_size.present?
    return if attachment.byte_size <= 5.megabytes

    errors.add(attachment_attribute, 'size should be less than 5MB')
  end

  class_methods do
    attr_accessor :attachment_attribute
  end
end
