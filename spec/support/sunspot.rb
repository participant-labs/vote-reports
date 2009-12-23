require 'sunspot/spec/extension'

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