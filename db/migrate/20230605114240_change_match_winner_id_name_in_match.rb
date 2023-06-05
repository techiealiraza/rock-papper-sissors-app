class ChangeMatchWinnerIdNameInMatch < ActiveRecord::Migration[6.1]
  def change
    rename_column :matches, :winner_id, :winner_id
  end
end
