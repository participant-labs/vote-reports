request_fixtures_path = Rails.root.join('spec/support/web_requests.marshal')

unless request_fixtures_path.exist?
  raise "Web request fixtures are missing. Generate them with 'rake web_requests:fixtures:generate'"
end

web_requests = Marshal.load(open(request_fixtures_path))

web_requests.each do |request|
  FakeWeb.register_uri(*request)
end

FakeWeb.allow_net_connect = %r{^http://localhost:8981/solr/}
