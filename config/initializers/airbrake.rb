def rescue_and_reraise
  yield
rescue => e
  notify_airbrake(e)
  raise
end

Airbrake.configure do |config|
  config.api_key = '5615579fbd5772fbf96c0fa21adce582'
end
