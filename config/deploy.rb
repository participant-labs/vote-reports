require 'auto_tagger/recipes'
require "bundler/capistrano"

set :domain, 'votereports-app'

server domain, :app, :web, :db, :primary => true

set :application, 'vote-reports'
set :stages, [:staging, :production]
set :auto_tagger_stages, stages
require 'capistrano/ext/multistage'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
set :rvm_type, :user
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@votereports'        # Or whatever env you want it to run in.

set :branch, 'rails31'

before "deploy:update_code", "release_tagger:set_branch"
after  "deploy", "release_tagger:create_tag"
after  "deploy", "release_tagger:write_tag_to_shared"
after  "deploy", "release_tagger:print_latest_tags"

set :user, 'deploy'

set :deploy_via, :remote_cache
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false

namespace :monit do
  task :reload do
    sudo "monit reload"
  end
end

namespace :delayed_job do
  task :start, :roles => :app do
    sudo "monit start delayed_job"
  end
  before "delayed_job:start", 'monit:reload'
  after "deploy:start", "delayed_job:start"

  task :stop, :roles => :app do
    sudo "monit stop delayed_job"
  end
  before "delayed_job:stop", 'monit:reload'
  after "deploy:stop", "delayed_job:stop"

  task :restart, :roles => :app do
    sudo "monit restart delayed_job"
  end
  before "delayed_job:restart", 'monit:reload'
  after "deploy:restart", "delayed_job:restart"
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
