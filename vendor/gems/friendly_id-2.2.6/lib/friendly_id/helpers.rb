module FriendlyId

  module Helpers
    private

    # Calculate expected result size for find_some_with_friendly (taken from
    # active_record/base.rb)
    def expected_size(ids_and_names, options) #:nodoc:#
      size =  ids_and_names.size - (options[:offset] || 0)
      size = options[:limit] if options[:limit] && size > options[:limit]
      size
    end

    def enforce_size!(results, ids_and_names, options)
      expected = expected_size(ids_and_names, options)
      if results.size != expected
        raise ActiveRecord::RecordNotFound,
          "Couldn't find all #{ name.pluralize } with IDs (#{ ids_and_names * ', ' }) AND #{ sanitize_sql options[:conditions] } (found #{ results.size } results, but was looking for #{ expected })"
      end
    end

    def split_names_and_ids(names_and_ids)
      names_and_ids.partition {|id_or_name| id_or_name.respond_to?(:to_str) && id_or_name.to_str }
    end
  end
end
