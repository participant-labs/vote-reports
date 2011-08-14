task :integrity_spec  => [:'integrity:setup', :spec]
task :integrity_cucumber => [:'integrity:setup', :cucumber]

namespace :integrity do
  task :setup do
    %w[database.yml secure_variables.rb].each do |path|
      FileUtils.cp("/srv/vote-reports/current/config/#{path}", Rails.root.to_s+"/config/#{path}")
    end
    FileUtils.mkdir_p(Rails.root.to_s + '/solr/pids/' + Rails.env)
    Rake::Task['sunspot:solr:start'].invoke
  end
end
