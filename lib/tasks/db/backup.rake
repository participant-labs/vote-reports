namespace :db do
  namespace :backup do
    task :full do
      require 'date'
      dest = '/var/www/votereports/production/shared/backup/db/full/'
      `mkdir -p #{dest}`
      `sudo -u postgres PGPASSWORD=monkey7paris pg_dump -Fc vote_reports_production > #{dest}/#{Date.today.to_s}.gz`
    end
  end
end