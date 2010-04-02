module FriendlyId
  module ActiveRecord2
    module SimpleModel
      def friendly_id
        self[friendly_id_config.column.to_sym]
      end
    end
  end
end
