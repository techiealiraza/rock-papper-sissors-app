class ChangeMatchWinnerIdNameInMatch < ActiveRecord::Migration[6.1]
  def change
    rename_column :matches, :match_winner_id, :winner_id
  end
end
