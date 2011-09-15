namespace :db do
  namespace :backup do
    task full: :environment do
      rescue_and_reraise do
        require 'date'
        dest = Rails.root.join('data/backup/db/full', Rails.env)
        FileUtils.mkdir_p dest
        `sudo -u postgres PGPASSWORD=monkey7paris pg_dump -Fc vote_reports_#{Rails.env} > #{dest.join("#{Date.today.to_s}.gz")}`
      end
    end

    task :restore do
      require 'rubygems'
      rescue_and_reraise do
        unless Rails.env.development? || ENV['IM_DEFINITELY_POPULATING_AN_EMPTY_DATABASE'] == 'true'
          raise "db:backup:restore is only for development unless you're populating a db you know is empty." +
            "Run it with IM_DEFINITELY_POPULATING_AN_EMPTY_DATABASE=true to go ahead with this"
        end

        path = 'data/backup/db/full/production'
        remote_path = "/srv/vote-reports/current/#{path}"
        local_path = Rails.root.join(path, ENV['FROM'])
        unless ENV['FROM'].present?
          ENV['COMMAND'] = "ls #{remote_path}"
          `cap invoke`

          raise "You must specify a file to restore FROM"
        end
        chdir(local_path.dirname) do
          unless File.exist?(local_path)
            puts "Copying db file from server..."
            `scp vote-reports:#{remote_path}/#{local_path.basename} .`
          end
        end
        puts "Restoring db backup..."
        `pg_restore -h localhost -p 5432 -U postgres -d vote_reports_development #{local_path}`
        puts "Done."
      end
    end
  end
end
