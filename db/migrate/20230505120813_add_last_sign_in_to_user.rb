# frozen_string_literal: true

class AddLastSignInToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_sign_in_at, :datetime
  end
end
