set :domain, 'staging.votereports.org'
set :rails_env, "staging"

server domain, :app, :web, :db, :primary => true

namespace :sunspot do
  desc "Update the crontab file"
  task :start, :roles => :app do
    run "cd #{current_path} && rake sunspot:start RAILS_ENV=staging"
  end
  after "deploy:symlink", "sunspot:start"
end
