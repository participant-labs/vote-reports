set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :user, 'deploy'

set :deploy_via, :remote_cache
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false

require 'delayed/recipes'
after "deploy:start", "delayed_job:start"
after "deploy:stop", "delayed_job:stop"
after "deploy:restart", "delayed_job:restart"
