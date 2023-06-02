# frozen_string_literal: true

class AddLastCurrentSignInIpToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :current_sign_in_ip, :string
  end
end
