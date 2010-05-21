require 'auto_tagger/recipes'
set :stages, [:staging, :production]
set :autotagger_stages, stages
require 'capistrano/ext/multistage'

before "deploy:update_code", "release_tagger:set_branch"
after  "deploy", "release_tagger:create_tag"
after  "deploy", "release_tagger:write_tag_to_shared"
after  "deploy", "release_tagger:print_latest_tags"

set :user, 'deploy'

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


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
