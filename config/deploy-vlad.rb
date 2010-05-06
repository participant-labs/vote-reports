set :application, "votereports"
set :user, "root"
set :domain, "#{user}@74.50.49.156"
set :deploy_to, "/var/www/votereports/production/"
set :repository, 'git@github.com:Empact/vote-reports.git'

namespace :vlad do
  remote_task :internal_symlinks, :roles => :app do
    run [
      "ln -s #{shared_path}/data #{latest_release}/data",
      "ln -s #{shared_path}/config/secure_variables.rb #{latest_release}/config/secure_variables.rb",
      "ln -fs /usr/local/bin/passenger-memory-stats /usr/bin/passenger-memory-stats",
      "chown -R www-data:www-data #{latest_release}/public/assets"
    ].join(' && ')
  end

  remote_task :start_dj, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=production script/delayed_job stop"
    run "cd #{latest_release} && RAILS_ENV=production script/delayed_job start"
  end

  remote_task :setup_scheduling, :roles => :app do
    run "cd #{latest_release} && whenever --update-crontab #{application}"
  end

  remote_task :setup_assets, :roles => :app do
    run "cd #{latest_release} && jammit"
  end
end
