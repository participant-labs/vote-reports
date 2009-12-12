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

    task :reset do
      unless ENV['VERSION'].present?
        raise "VERSION argument required: supply the version of the DB that heroku is running"
      end
      Rake::Task['db:drop'].invoke
      `sudo -u postgres createdb vote_reports_development`

      Rake::Task['db:migrate'].invoke
      Rake::Task['db:heroku:pull'].invoke

      ENV.delete('VERSION')
      Rake::Task['db:migrate'].reenable
      Rake::Task['db:migrate'].invoke
    end
  end
end