class RemoveWinnerScoreFromMatches < ActiveRecord::Migration[6.1]
  def change
    remove_column :matches, :winner_score
  end
end
