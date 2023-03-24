class CreateTournamentsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments_users do |t|
      t.integer :tournament_id
      t.integer :user_id

      t.timestamps
    end
  end
end
