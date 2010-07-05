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

every 1.day do
  runner "Politician.update_current_office_status!"
end

every 1.days do
  rake "gov_track:download_all"
  rake "gov_track:politicians:unpack"  # 18.0m
  rake "gov_track:committees:unpack"   #  2.5m
  env 'UPDATE', true
  env 'MEETING', 111
  rake "gov_track:bills:unpack"
  rake "gov_track:amendments:unpack"
  rake "gov_track:votes:unpack"

  rake "sunlight:politicians:download"
  rake "sunlight:politicians:unpack"

  runner "Politician.update_titles!"
  runner "ContinuousTerm.regenerate!"
end

# Learn more: http://github.com/javan/whenever
