# frozen_literal_string: true
# app/models/concerns/image_validatable.rb
module ImageValidatable
  extend ActiveSupport::Concern

  included do
    validate on: %i[create update], unless: :skip_validation? do
      validate :validate_image_type
      validate :validate_image_size
    end
  end

  private

  def skip_validation?
    !image.attached?
  end

  def validate_image_type
    return unless image.attached? && !image.content_typecontent_type.in?(%w[image/png image/jpeg image/jpg])

    errors.add(:image, 'must be a JPG, JPEG or PNG')
  end

  def validate_image_size
    return unless image.attached? && image.byte_size > 5.megabytes

    errors.add(:image, 'size should be less than 5MB')
  end
end
