task :integrity_spec  => [:'integrity:setup', :'db:test:prepare', :spec]
task :integrity_cucumber => [:'integrity:setup', :'db:test:prepare', :cucumber]

namespace :integrity do
  task :setup do
    %w[database.yml secure_variables.rb].each do |path|
      FileUtils.cp("/srv/vote-reports/current/config/#{path}", RAILS_ROOT+"/config/#{path}")
    end
  end
end
