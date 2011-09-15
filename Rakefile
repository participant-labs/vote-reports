# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'

VoteReports::Application.load_tasks

begin
  require 'hoptoad_notifier'

  def rescue_and_reraise
    yield
  rescue => e
    HoptoadNotifier.notify(e)
    raise
  end
rescue LoadError
  puts "hoptoad_notifier not available"
end

task default: [:spec, :'cucumber:rerun']

task :update do
  Rake::Task['gov_track:download_all'].invoke
  Rake::Task['gov_track:politicians:unpack'].invoke  # 18.0m
  Rake::Task['gov_track:committees:unpack'].invoke  #  2.5m
  Rake::Task["gov_track:bills:unpack"].invoke
  Rake::Task["gov_track:amendments:unpack"].invoke
  Rake::Task["gov_track:votes:unpack"].invoke

  Rake::Task["sunlight:politicians:download"].invoke
  Rake::Task["sunlight:politicians:unpack"].invoke

  Politician.update_current_office_status!
  Politician.update_titles!
  ContinuousTerm.regenerate!
end
