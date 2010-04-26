namespace :db do
  namespace :backup do
    task :full => :environment do
      begin
        require 'date'
        dest = Rails.root.join('data/backup/db/full', Rails.env)
        FileUtils.mkdir_p dest
        `sudo -u postgres PGPASSWORD=monkey7paris pg_dump -Fc vote_reports_#{Rails.env} > #{dest.join("#{Date.today.to_s}.gz")}`
      rescue Exception => e
        notify_exceptional(e)
        raise
      end
    end
  end
end
