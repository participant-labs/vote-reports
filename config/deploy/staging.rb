set :domain, 'staging.votereports.org'
set :rails_env, "staging"

server domain, :app, :web, :db, :primary => true

namespace :sunspot do
  desc "Update the crontab file"
  task :start, :roles => :app do
    run "cd #{current_path} && rake sunspot:solr:start RAILS_ENV=production"
  end
  after "deploy:symlink", "sunspot:start"
end
