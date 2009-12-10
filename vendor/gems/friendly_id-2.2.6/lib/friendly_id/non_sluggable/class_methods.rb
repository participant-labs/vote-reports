require "friendly_id/helpers"

module FriendlyId
  module NonSluggable
    module ClassMethods

      include FriendlyId::Helpers

      protected

      def find_one(id, options) #:nodoc:#
        if id.respond_to?(:to_str) && result = send("find_by_#{ friendly_id_options[:method] }", id.to_str, options)
          result.instance_variable_set(:@found_using_friendly_id, true)
          result
        else
          super
        end
      end

      def find_some(ids_and_names, options) #:nodoc:#

        names, ids = split_names_and_ids(ids_and_names)
        results = with_scope :find => options do
          find :all, :conditions => [
            "#{quoted_table_name}.#{primary_key} IN (?) OR #{friendly_id_options[:method]} IN (?)",
            ids, names]
        end

        enforce_size!(results, ids_and_names, options)

        results.each do |r|
          r.instance_variable_set(:@found_using_friendly_id, true) if names.include?(r.friendly_id)
        end

        results

      end

    end
  end
end
