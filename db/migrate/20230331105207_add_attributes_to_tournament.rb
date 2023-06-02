# frozen_string_literal: true

class AddAttributesToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :registration_deadline, :datetime
  end
end
