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
end
