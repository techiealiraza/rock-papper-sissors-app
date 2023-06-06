# frozen_string_literal: true

module ApplicationHelper
  def custom_index(collection, index)
    per_page = collection.limit_value
    starting_index = (collection.current_page - 1) * per_page + 1
    starting_index + index
  end
end
