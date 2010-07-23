# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
config.action_controller.asset_host = "http://assets%d.votereports.org"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

all_plugins = self.class.send(:find_plugins, config.plugin_paths).map {|path| File.basename(path)}
config.plugins = all_plugins - %w[parallel_tests]

# Enable threaded mode
# config.threadsafe!

config.gem 'scout'
config.gem 'request-log-analyzer', :lib => 'request_log_analyzer'
