# frozen_string_literal: true

class AddTriesToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :tries, :integer, default: 3
  end
end
