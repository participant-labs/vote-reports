set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# server 'votereports.org', :app, :web, :db, :primary => true
server 'staging.votereports.org', :app, :web, :db, :primary => true
