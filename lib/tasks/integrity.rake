task :integrity  => [:'integrity:setup_db', :'db:test:prepare', :spec, :cucumber]

namespace :integrity do
  task :setup_db do
    FileUtils.cp(RAILS_ROOT+"/config/integrity/database.yml", RAILS_ROOT+"/config/database.yml")
  end
end
