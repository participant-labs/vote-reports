set :user, 'deploy'

# server 'votereports.org', :app, :web, :db, :primary => true
server 'staging.votereports.org', :app, :web, :db, :primary => true

set :deploy_via, :remote_cache
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false
