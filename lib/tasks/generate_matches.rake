namespace :generate_matches do
  desc 'Generate matches for a given tournament'
  task generate_matches: :environment do
    MatchesController.generate_matches
  end
end
