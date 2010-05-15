set :domain, 'staging.votereports.org'
set :rails_env, "staging"

server domain, :app, :web, :db, :primary => true
