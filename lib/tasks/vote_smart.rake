namespace :vote_smart do
  task import: :environment do
    require 'vote_smart/importer'
    VoteSmart::Importer.import_all
  end

  task import_races: :environment do
    require 'vote_smart/importer'
    VoteSmart::Importer.import_races
  end

  task import_elections: :environment do
    require 'vote_smart/importer'
    VoteSmart::Importer.import_elections
  end

  task import_ratings: :environment do
    require 'vote_smart/importer'
    VoteSmart::Importer.import_ratings
  end

  task import_interest_groups: :environment do
    require 'vote_smart/importer'
    VoteSmart::Importer.import_interest_groups
  end
end
