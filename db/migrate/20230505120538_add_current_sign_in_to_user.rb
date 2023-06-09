# frozen_string_literal: true

class AddCurrentSignInToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :current_sign_in_at, :datetime
  end
end
