require 'sunspot/rails/tasks'

namespace :sunspot do
  task :start do
    `rake sunspot:solr:start RAILS_ENV=development`
    `rake sunspot:solr:start RAILS_ENV=test`
    `rake sunspot:solr:start RAILS_ENV=production`
  end

  task :reindex => [:'bills:reindex', :'reports:reindex']

  namespace :bills do
    task :reindex => :environment do
      Bill.reindex
    end
  end

  namespace :reports do
    task :reindex => :environment do
      Report.reindex
    end
  end
end