begin
  require Rails.root.join('config/secure_variables')
rescue LoadError
end

RPX_API_KEY = ENV['RPX_API_KEY'] unless defined?(RPX_API_KEY)
RPX_APP_NAME = 'VoteReports'
