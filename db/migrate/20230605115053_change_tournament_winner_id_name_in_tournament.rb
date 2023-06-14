class ChangeTournamentWinnerIdNameInTournament < ActiveRecord::Migration[6.1]
  def change
    rename_column :tournaments, :tournament_winner_id, :winner_id
  end
end
