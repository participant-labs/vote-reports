namespace :db do
  namespace :heroku do
    def db_url(environment)
      require 'yaml'
      config = YAML.load(open(Rails.root.join('config/database.yml'))).fetch(environment)
      "postgres://#{config['username']}:#{config['password']}@#{config['host']}/#{config['database']}"
    end

    task :pull do
      `heroku db:pull #{db_url('development')}`
    end
  end
end