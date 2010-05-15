task :integrity  => [:'integrity:setup_db', :'db:test:prepare', :spec, :cucumber]

namespace :integrity do
  task :setup_db do
    FileUtils.cp("/srv/vote-reports/current/config/database.yml", RAILS_ROOT+"/config/database.yml")
  end
end
