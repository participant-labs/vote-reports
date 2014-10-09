# Sunspot.config.solr.url = 'http://127.0.0.1:8981/solr'

# Before do
#   Sunspot.remove_all!
# end

# require 'sunspot/rails/spec_helper'

Before do
  Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
end

After do
  Sunspot.session = Sunspot.session.original_session
end
