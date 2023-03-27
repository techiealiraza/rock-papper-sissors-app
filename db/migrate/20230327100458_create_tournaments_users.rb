class CreateTournamentsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
