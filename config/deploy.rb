# require 'auto_tagger/recipes'
require "bundler/capistrano"

set :domain, 'votereports-app'

server domain, :app, :web, :db, primary: true

set :use_sudo, false
set :application, 'vote-reports'
set :stages, [:staging, :production]
# set :auto_tagger_stages, stages
require 'capistrano/ext/multistage'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@votereports'        # Or whatever env you want it to run in.
set :rvm_type, :user

ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :scm, "git"
set :repository, 'git@github.com:Empact/vote-reports.git'
set :branch, 'master'

set :deploy_to, '/srv/vote-reports/'

# before "deploy:update_code", "release_tagger:set_branch"
# after  "deploy", "release_tagger:create_tag"
# after  "deploy", "release_tagger:write_tag_to_shared"
# after  "deploy", "release_tagger:print_latest_tags"

set :user, 'deploy'

set :copy_exclude, [".git"]
set :use_sudo, false

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end
after "deploy:update_code", "rvm:trust_rvmrc"

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_configs, roles: :app do
    %w[
        database.yml
        mongo.yml
        facebooker.yml
        newrelic.yml
        secure_variables.rb
        initializers/secret_token.rb
      ].each do |file|
      run "ln -nfs #{deploy_to}/shared/config/#{file} #{release_path}/config/#{file}"
    end
    %w[data].each do |path|
      run "ln -nfs #{deploy_to}/shared/#{path} #{release_path}/#{path}"
    end
  end
end
after 'deploy:update_code', 'deploy:symlink_configs'

namespace :monit do
  task :reload do
    sudo "monit reload"
  end
end

namespace :delayed_job do
  task :start, roles: :app do
    sudo "monit start delayed_job"
  end
  before "delayed_job:start", 'monit:reload'
  after "deploy:start", "delayed_job:start"

  task :stop, roles: :app do
    sudo "monit stop delayed_job"
  end
  before "delayed_job:stop", 'monit:reload'
  after "deploy:stop", "delayed_job:stop"

  task :restart, roles: :app do
    sudo "monit restart delayed_job"
  end
  before "delayed_job:restart", 'monit:reload'
  after "deploy:restart", "delayed_job:restart"
end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
after :deploy, "passenger:restart"

require './config/boot'
require 'airbrake/capistrano'
