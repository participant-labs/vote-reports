# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end

set :output, "/srv/vote-reports/shared/log/cron_log.log"

every 7.days do
  rake "db:backup:full"
end

every 1.day do
  rake "gov_track:download_all"
  rake "gov_track:politicians:unpack"
end

every 1.minute do
  command "/usr/local/bin/scout 53a8a406-6297-4ab9-8763-21f8266b9968"
end

# Learn more: http://github.com/javan/whenever
