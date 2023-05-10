# frozen_string_literal: true

class AddWinnerToSelection < ActiveRecord::Migration[6.1]
  def change
    add_column :selections, :winner, :bool, default: false
  end
end
