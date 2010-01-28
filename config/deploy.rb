set :application, "votereports"
set :user, "root"
set :domain, "#{user}@74.50.53.183"
set :deploy_to, "/var/www/votereports/production/"
set :repository, 'git@github.com:Empact/vote-reports.git'
set :revision, "origin/rimu"

namespace :vlad do
  desc "custom deploy"
  task :deploy => [:update, :symlinks, :install_gems, :migrate, :setup_scheduling, :touch_restart]

  remote_task :touch_restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  remote_task :symlinks, :roles => :app do
    run [
      "ln -s #{current_release}/config/database.rimu.yml #{current_release}/config/database.yml",
    ].join(' && ')
  end

  remote_task :install_gems, :roles => :app do
    run "cd #{current_release} && rake gems:install"
  end

  remote_task :setup_scheduling, :roles => :app do
    run "cd #{current_release} && whenever --update-crontab #{application}"
  end
end