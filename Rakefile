# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'hoptoad_notifier'
def rescue_and_reraise
  yield
rescue => e
  HoptoadNotifier.notify(e)
  raise
end

task :default => [:spec, :cucumber]
