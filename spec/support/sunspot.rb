require 'sunspot/rails/spec_helper'

$original_sunspot_session = Sunspot.session

RSpec.configure do |config|
  config.before(:each) do
    Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
  end

  config.after(:each) do
    Sunspot.session = Sunspot.session.original_session
  end
end

module SolrSpecHelper
  def solr_setup
    unless $sunspot
      $sunspot = Sunspot::Rails::Server.new

      pid = fork do
        STDERR.reopen('/dev/null')
        STDOUT.reopen('/dev/null')
        $sunspot.run
      end
      # shut down the Solr server
      at_exit { Process.kill('TERM', pid) }
      # wait for solr to start
      sleep 5
    end

    Sunspot.session = $original_sunspot_session
  end
end

module Sunspot
  module Rails
    module Spec
      module Extension
        def mock_sunspot
          stub(Sunspot).index
          stub(Sunspot).remove_from_index
        end
      end
    end
  end
end
