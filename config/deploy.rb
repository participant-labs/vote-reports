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

namespace :deploy do
  desc 'Bundle and minify the JS and CSS files'
  task :precache_assets, :roles => :app do
    root_path = File.expand_path(File.dirname(__FILE__) + '/..')
    run_locally "jammit"
    top.upload "#{root_path}/public/assets", "#{current_release}/public", :via => :scp, :recursive => true
  end
  after 'deploy:symlink', 'deploy:precache_assets'

  task :optimize_pngs, :roles => :app do
    run %{find #{current_release}/public/images #{current_release}/public/system -name "*.png" | xargs optipng}
  end
  after 'deploy:symlink', 'deploy:optimize_pngs'
end

namespace :monit do
  task :reload do
    run "monit reload"
  end
end

namespace :delayed_job do
  task :start, :roles => :app do
    run "monit start delayed_job"
  end
  before "delayed_job:start", 'monit:reload'
  after "deploy:start", "delayed_job:start"

  task :stop, :roles => :app do
    run "monit stop delayed_job"
  end
  before "delayed_job:stop", 'monit:reload'
  after "deploy:stop", "delayed_job:stop"

  task :restart, :roles => :app do
    run "monit restart delayed_job"
  end
  before "delayed_job:restart", 'monit:reload'
  after "deploy:restart", "delayed_job:restart"
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
