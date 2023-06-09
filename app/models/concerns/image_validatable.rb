# app/models/concerns/image_validatable.rb
module ImageValidatable
  extend ActiveSupport::Concern

  included do
    validate :validate_image_type
    validate :validate_image_size
  end

  private

  def validate_image_type
    return unless image.attached? && !image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, 'must be a JPEG or PNG')
  end

  def validate_image_size
    return unless image.attached? && image.byte_size > 10.megabytes

    errors.add(:image, 'size should be less than 10MB')
  end
end
