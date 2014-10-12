require 'sunspot/rails/spec_helper'

$sunspot_original_session = Sunspot.session
$sunspot_stub_sesion = Sunspot::Rails::StubSessionProxy.new($sunspot_original_session)
Sunspot.session = $sunspot_stub_sesion

RSpec.configure do |config|
  config.before(:each) do |example|
    Sunspot.session =
      if example.metadata[:solr]
        $sunspot_original_session
      else
        $sunspot_stub_sesion
      end
  end

  config.before(:all, :solr) do
    unless $sunspot_server
      $sunspot_server = Sunspot::Rails::Server.new

      pid = fork do
        STDERR.reopen('/dev/null')
        STDOUT.reopen('/dev/null')
        $sunspot_server.run
      end
      # shut down the Solr server
      at_exit { Process.kill('TERM', pid) }
      # wait for solr to start
      sleep 5
    end
  end

  config.after(:all, :solr) do
    Sunspot.searchable.each do |klass|
      klass.solr_remove_all_from_index!
    end
  end
end
