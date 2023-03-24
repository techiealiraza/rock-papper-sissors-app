json.extract! tournament, :id, :name, :description, :start_date, :end_date, :tournament_winner_id, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
