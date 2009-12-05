request_fixtures_path = File.join(File.dirname(__FILE__), 'web_requests.marshal')

unless File.exist?(request_fixtures_path)
  Rake.application['web_requests:fixtures:generate'].invoke
end

web_requests = Marshal.load(open(request_fixtures_path))

web_requests.each do |request|
  FakeWeb.register_uri(*request)
end

FakeWeb.allow_net_connect = false
