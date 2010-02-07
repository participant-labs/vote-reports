set :application, "votereports"
set :user, "root"
set :domain, "#{user}@74.50.53.183"
set :deploy_to, "/var/www/votereports/production/"
set :repository, 'git@github.com:Empact/vote-reports.git'

namespace :vlad do
  desc "custom deploy"
  task :update_symlinks => :internal_symlinks
  task :deploy => [:update, :install_gems, :migrate, :setup_scheduling, :start_solr, :start]

  remote_task :internal_symlinks, :roles => :app do
    run [
      "ln -s #{latest_release}/config/database.rimu.yml #{latest_release}/config/database.yml",
      "ln -s #{shared_path}/data #{latest_release}/data"
    ].join(' && ')
  end

  remote_task :install_gems, :roles => :app do
    run "cd #{latest_release} && rake gems:install"
  end

  remote_task :start_solr, :roles => :app do
    run "cd #{latest_release} && rake sunspot:solr:start RAILS_ENV=production"
  end

  remote_task :setup_scheduling, :roles => :app do
    run "cd #{latest_release} && whenever --update-crontab #{application}"
  end
end