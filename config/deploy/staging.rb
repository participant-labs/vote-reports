set :rails_env, "staging"

server 'staging.votereports.org', :app, :web, :db, :primary => true
