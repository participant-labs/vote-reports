namespace :vote_smart do
  task :import => :environment do
    VoteSmart::Importer.import_all
  end
end