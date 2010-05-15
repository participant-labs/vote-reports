set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :user, 'deploy'
set :port, 7111

set :deploy_via, :remote_cache
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false

require 'delayed/recipes'
after "deploy:start", "delayed_job:start"
after "deploy:stop", "delayed_job:stop"
after "deploy:restart", "delayed_job:restart"

namespace :deploy do
  desc 'Bundle and minify the JS and CSS files'
  task :precache_assets, :roles => :app do
    root_path = File.expand_path(File.dirname(__FILE__) + '/..')
    run_locally "jammit"
    top.upload "#{root_path}/public/assets", "#{current_release}/public", :via => :scp, :recursive => true
  end
  after 'deploy:symlink', 'deploy:precache_assets'

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
  after "deploy:symlink", "deploy:update_crontab"
end
