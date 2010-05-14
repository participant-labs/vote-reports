set :rails_env, "staging"
set :user, 'deploy'

server 'staging.votereports.org', :app, :web, :db, :primary => true
