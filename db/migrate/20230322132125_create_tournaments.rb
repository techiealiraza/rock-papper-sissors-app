# frozen_string_literal: true

class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :tournament_winner_id

      t.timestamps
    end
  end
end
