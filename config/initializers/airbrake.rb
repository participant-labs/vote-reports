Airbrake.configure do |config|
  config.api_key = ENV['VOTEREPORTS_AIRBRAKE_API_KEY']
end

def rescue_and_reraise
  yield
rescue => e
  Airbrake.notify(e)
  raise
end
