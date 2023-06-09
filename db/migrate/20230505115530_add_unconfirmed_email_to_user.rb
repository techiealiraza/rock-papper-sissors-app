# frozen_string_literal: true

class AddUnconfirmedEmailToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :unconfirmed_email, :string
  end
end
