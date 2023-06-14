# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.integer :winner_id
      t.integer :winner_score
      t.datetime :match_time
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
