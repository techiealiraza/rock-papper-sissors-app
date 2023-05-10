# frozen_string_literal: true

namespace :generate_match do
  desc 'Generate matches for a given tournament'
  task generate_matches: :environment do
    MatchesController.generate_matches
  end
end
