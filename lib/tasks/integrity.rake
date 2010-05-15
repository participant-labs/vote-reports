task :integrity_spec  => [:'integrity:setup', :spec]
task :integrity_cucumber => [:'integrity:setup', :cucumber]

namespace :integrity do
  task :setup do
    %w[database.yml secure_variables.rb].each do |path|
      FileUtils.cp("/srv/vote-reports/current/config/#{path}", RAILS_ROOT+"/config/#{path}")
    end
    FileUtils.mkdir_p(RAILS_ROOT + '/solr/pids/' + RAILS_ENV)
    Rake::Task['sunspot:solr:start'].invoke
  end
end
