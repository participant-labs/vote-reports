set :application, "votereports"
set :user, "root"
set :domain, "#{user}@74.50.53.183"
set :deploy_to, "/var/www/votereports/production/"
set :repository, 'git@github.com:Empact/vote-reports.git'

namespace :vlad do
  desc "custom deploy"
  task :deploy => [:update, :symlinks, :gem_bundle, :migrate, :touch_restart]

  remote_task :touch_restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  remote_task :symlinks, :roles => :app do
    run [
      "ln -s #{shared_path}/config/database.yml #{current_release}/config/database.yml",
      "ln -s #{shared_path}/bundler/gems #{current_release}/vendor/bundler_gems",
      "ln -s #{shared_path}/bundler/bin #{current_release}/bin"
    ].join(' && ')
  end

  remote_task :gem_bundle, :roles => :app do
    run "cd #{current_release} && gem bundle --build-options #{shared_path}/bundler/build_options.yml"
  end
end