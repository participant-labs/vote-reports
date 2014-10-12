# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

ruby '2.1.3'

gem 'rails', '4.1.6'

gem 'ancestry', '>=1.2.0'
gem 'authlogic'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2'
gem 'bluecloth', '>=2.0.5'
gem 'declarative_authorization'
gem 'erubis', '>= 2.6.6'
gem 'excelsior'
gem 'foreigner'
gem 'friendly_id'
gem 'babosa'
gem 'geokit-rails'
gem 'gravtastic', '= 3.1.0'
gem 'airbrake'
gem 'loofah'
gem 'newrelic_rpm', '>= 2.12.3'
gem 'nokogiri'
gem 'paperclip', '>= 2.3.3'
gem 'pg'

# Geo
gem 'georuby', require: 'geo_ruby'

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

gem 'kaminari'
gem 'sunspot_rails'
gem 'sunspot_with_kaminari'
gem 'Paperclip-Autosizer'

# Views
gem 'dynamic_form'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

# Background Processing
gem 'delayed_job_active_record'
gem 'daemons'

group :development do
  # Dev
  gem 'spring'
  gem 'thin'
  gem 'sunspot_solr'

  gem 'dotenv-rails'

  # Deployment
  gem 'rvm'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'auto_tagger'
end

group :test, :development do
  gem 'byebug', require: false

  gem "rspec-rails"
end

group :test do
  # Test
  gem 'fakeweb'

  # Cucumber
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'

  # Fixtures
  gem 'factory_girl_rails'
  gem 'forgery'
end
