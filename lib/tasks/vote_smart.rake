namespace :vote_smart do
  task :import => :environment do
    VoteSmart::Importer.import_all
  end

  task :import_races => :environment do
    VoteSmart::Importer.import_races
  end

  task :import_ratings => :environment do
    VoteSmart::Importer.import_ratings
  end

  task :import_interest_groups => :environment do
    VoteSmart::Importer.import_interest_groups
  end
end