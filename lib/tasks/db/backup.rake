namespace :db do
  namespace :backup do
    task :full => :environment do
      Exceptional.rescue_and_reraise do
        require 'date'
        dest = Rails.root.join('data/backup/db/full', Rails.env)
        FileUtils.mkdir_p dest
        `sudo -u postgres PGPASSWORD=monkey7paris pg_dump -Fc vote_reports_#{Rails.env} > #{dest.join("#{Date.today.to_s}.gz")}`
      end
    end

    task :restore do
      Exceptional.rescue_and_reraise do
        raise "You must specify a file to restore from" unless ENV['PATH'].present?
        `pg_restore -h localhost -p 5432 -U postgres -d vote_reports_#{Rails.env} #{ENV['PATH']}`
      end
    end
  end
end
