# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.1.8'

gem 'ancestry', '>=1.2.0'
gem 'Empact-authlogic', '>=3.0.3', require: 'authlogic'
gem 'Empact-authlogic_rpx', '>= 2.0.0', require: 'authlogic_rpx'
gem 'bluecloth', '>=2.0.5'
gem 'declarative_authorization'
gem 'erubis', '>= 2.6.6'
gem 'excelsior'
gem 'foreigner'
gem 'friendly_id', '>= 4.0.0'
gem 'babosa'
gem 'geokit'
gem 'gravtastic', '= 3.1.0'
gem 'airbrake'
gem 'loofah'
gem 'bson_ext'
gem 'mongo_mapper'
gem 'newrelic_rpm', '>= 2.12.3'
gem 'nokogiri'
gem 'paperclip', '>= 2.3.3'
gem 'pg'
gem 'rpx_now', '>= 0.6.12'

#Models
gem 'Empact-sexy_pg_constraints', require: 'sexy_pg_constraints'
gem 'state_machine'
gem 'activerecord-postgis-adapter'
gem 'Empact-activerecord-import', '>= 0.3.4', require: 'activerecord-import'

gem 'tamtam'
gem 'typhoeus'
gem 'votesmart', '>= 0.3.3'
gem 'ym4r'
gem 'httparty'
gem 'parallel'

# Models
gem 'kaminari'
gem 'sunspot_rails'
gem 'sunspot_with_kaminari'
gem 'Paperclip-Autosizer'

# Views
gem 'dynamic_form'

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

# Background Processing
gem 'delayed_job_active_record'
gem 'daemons'

group :development do
  # Dev
  gem 'thin'
  gem 'sunspot_solr'

  # Deployment
  gem 'rvm'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'auto_tagger'
end

group :test, :development do
  gem 'debugger', require: false

  gem "rspec-rails"
end

group :test do
  # Test
  gem 'fakeweb'
  gem 'rr', github: 'Empact/rr'

  # Cucumber
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'

  # Fixtures
  gem 'fixjour'
  gem 'forgery'
  gem 'georuby', require: 'geo_ruby'
end
