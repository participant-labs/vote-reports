set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :user, 'deploy'

set :deploy_via, :remote_cache
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false
