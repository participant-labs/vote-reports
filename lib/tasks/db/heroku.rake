namespace :db do
  namespace :heroku do
    def db_url(environment)
      require 'yaml'
      config = YAML.load(open(Rails.root.join('config/database.yml'))).fetch(environment)
      "postgres://#{config['username']}:#{config['password']}@#{config['host']}/#{config['database']}"
    end

    task :pull do
      puts "heroku db:pull #{db_url('development')}"
    end

    task :push do
      puts "heroku db:push #{db_url('development')}"
    end

    task :reset do
      Rake::Task['db:drop'].invoke
      `sudo -u postgres createdb vote_reports_development`

      Rake::Task['db:heroku:pull'].invoke
      Rake::Task['db:migrate'].invoke
    end
  end
end