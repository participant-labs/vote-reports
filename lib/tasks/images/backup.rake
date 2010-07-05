namespace :images do
  task :backup => :environment do
    rescue_and_reraise do
      require 'date'
      dest = Rails.root.join('data/backup/system')
      FileUtils.mkdir_p dest
      `tar -zcvf #{dest.join("#{Date.today.to_s}.tar")} public/system &> /dev/null`
    end
  end

  task :sync do
    `rsync -avz -e ssh votereports.org:/srv/vote-reports/current/public/system/ public/system/`
  end
end
