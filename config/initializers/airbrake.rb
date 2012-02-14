Airbrake.configure do |config|
  config.api_key = '5615579fbd5772fbf96c0fa21adce582'
end

def rescue_and_reraise
  yield
rescue => e
  Airbrake.notify(e)
  raise
end
