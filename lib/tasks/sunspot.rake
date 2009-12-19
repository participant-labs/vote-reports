require 'sunspot/rails/tasks'

namespace :sunspot do
  task :start do
    `rake sunspot:solr:start RAILS_ENV=development`
    `rake sunspot:solr:start RAILS_ENV=test`
    `rake sunspot:solr:start RAILS_ENV=production`
  end
end