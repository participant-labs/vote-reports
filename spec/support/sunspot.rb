require 'sunspot/rails/spec_helper'

$original_sunspot_session = Sunspot.session
Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)

module SolrSpecHelper
  extend ActiveSupport::Concern

  included do
    before(:all) do
      Sunspot.session = Sunspot.session.original_session
    end

    after do
      Sunspot.remove_all! 
    end

    after(:all) do
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
    end
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