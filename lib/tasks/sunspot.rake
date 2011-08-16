begin
  require 'sunspot/rails/tasks'
rescue LoadError
  # do nothing
end

namespace :sunspot do
  task :start do
    `rake sunspot:solr:start RAILS_ENV=development`
    `rake sunspot:solr:start RAILS_ENV=test`
    `rake sunspot:solr:start RAILS_ENV=staging`
    `rake sunspot:solr:start RAILS_ENV=production`
  end

  task :reindex => [:'bills:reindex', :'reports:reindex', :'subjects:reindex']

  namespace :bills do
    task :reindex => :environment do
      Bill.solr_reindex
    end
  end

  namespace :reports do
    task :reindex => :environment do
      Report.solr_reindex
    end
  end

  namespace :subjects do
    task :reindex => :environment do
      Subject.solr_reindex
    end
  end
end