# frozen_string_literal: true

class CreateUsersMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :users_matches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
