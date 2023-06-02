# frozen_string_literal: true

class CreateSelections < ActiveRecord::Migration[6.1]
  def change
    create_table :selections do |t|
      t.references :match
      t.integer :user
      t.string :selection

      t.timestamps
    end
  end
end
