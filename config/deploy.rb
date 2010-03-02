set :application, "votereports"
set :user, "root"
set :domain, "#{user}@74.50.49.156"
set :deploy_to, "/var/www/votereports/production/"
set :repository, 'git@github.com:Empact/vote-reports.git'

namespace :vlad do
  desc "custom deploy"
  task :update_symlinks => [:internal_symlinks]
  task :deploy => [:update, :install_gems, :migrate, :setup_scheduling, :start_dj, :setup_assets, :start]

  set :rake_cmd, 'nice -n 3 rake'
  set :web_command, "apache2ctl"

  remote_task :internal_symlinks, :roles => :app do
    run [
      "ln -s #{latest_release}/config/database.rimu.yml #{latest_release}/config/database.yml",
      "ln -s #{shared_path}/data #{latest_release}/data",
      "ln -s #{shared_path}/assets #{latest_release}/public/assets",
      "ln -s #{shared_path}/config/secure_variables.rb #{latest_release}/config/secure_variables.rb"
    ].join(' && ')
  end

  remote_task :install_gems, :roles => :app do
    run "cd #{latest_release} && rake gems:install"
  end

  remote_task :start_dj, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=production script/delayed_job start"
  end

  remote_task :setup_scheduling, :roles => :app do
    run "cd #{latest_release} && whenever --update-crontab #{application}"
  end

  remote_task :setup_assets, :roles => :app do
    run "cd #{latest_release} && jammit"
  end
end