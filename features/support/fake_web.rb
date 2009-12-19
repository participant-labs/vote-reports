module FakeWebSupport
  require Rails.root.join('spec/support/fake_web')
  
  FakeWeb.allow_net_connect = %r{^http://localhost:8983/solr/}
end

World(FakeWebSupport)
