# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.autoload_paths += [Rails.root.join('lib/extensions').to_s]

  config.plugins = [:all]

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  config.gem 'ancestry', :version => '>=1.2.0'
  config.gem "Empact-authlogic", :lib => 'authlogic', :version => '>=2.1.5'
  config.gem 'Empact-authlogic_rpx', :lib => 'authlogic_rpx', :version => '>= 1.1.8'
  config.gem 'bluecloth', :version => '>=2.0.5'
  config.gem "declarative_authorization"
  config.gem 'delayed_job', :version => '>= 2.0.3'
  config.gem 'erubis', :version => '>= 2.6.6'
  config.gem 'excelsior'
  config.gem 'fastercsv'
  config.gem "foreigner"
  config.gem 'friendly_id', :version => '>= 3.0.6'
  config.gem 'geokit'
  config.gem 'gravtastic', :version => '= 3.1.0'
  config.gem 'hoptoad_notifier', :version => '>= 2.3.2'
  config.gem 'jammit', :version => '>= 0.5.3'
  config.gem 'json', :version => '>= 1.4.3'
  config.gem 'loofah'
  config.gem 'puppet', :version => '>= 2.6.0'
  config.gem 'shadow_puppet', :version => '>= 0.3.3'
  config.gem 'bson_ext', :version => '= 1.0.4', :lib => false
  config.gem 'bson', :version => '= 1.0.4'
  config.gem 'mongo', :version => '= 1.0.6'
  config.gem 'plucky', :version => '= 0.3.2'
  config.gem 'mongo_mapper', :version => '= 0.8.2'
  config.gem 'Empact-mongo_session_store', :lib => 'mongo_session_store'
  config.gem 'newrelic_rpm', :version => '>= 2.12.3'
  config.gem 'nokogiri'
  config.gem 'paperclip', :version => '>= 2.3.3'
  config.gem 'pg'
  config.gem 'rpx_now', :version => '>= 0.6.12'
  config.gem 'rsruby', :lib => false
  config.gem 'sexy_pg_constraints'
  config.gem 'state_machine'
  config.gem 'spatial_adapter'
  config.gem 'sunspot', :lib => 'sunspot', :version => '= 1.1.0'
  config.gem 'sunspot_rails', :lib => 'sunspot/rails', :version => '= 1.1.0'
  config.gem 'polly-suppress_validations', :source => "http://gems.github.com", :lib => 'suppress_validations'
  config.gem 'tamtam'
  config.gem 'typhoeus'
  config.gem 'votesmart', :version => '>= 0.3.3'
  config.gem 'will_paginate', :version => '>=2.3.15'
  config.gem 'ym4r'
  config.gem 'httparty'
  config.gem 'parallel' # only needed because parallel_test is a plugin... lame

  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

require 'core_extensions'
