namespace :db do
  namespace :backup do
    task :full => :environment do
      require 'date'
      dest = Rails.root.join('data/backup/db/full', Rails.env)
      `mkdir -p #{dest}`
      `sudo -u postgres PGPASSWORD=monkey7paris pg_dump -Fc vote_reports_#{Rails.env} > #{dest.join("#{Date.today.to_s}.gz")}`
    end
  end
end
