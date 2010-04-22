module ActionController
  module Resources
    class Resource #:nodoc:
      def path_prefix
        @path_prefix unless @path_prefix.blank?
      end

      def path_segment
        @path_segment unless @path_segment.blank?
      end

      def path
        @path ||= [path_prefix, path_segment].compact.join("/")
      end

      def member_path
        @member_path ||= [shallow_path_prefix, path_segment, ":id"].compact.join("/")
      end

      def nesting_path_prefix
        @nesting_path_prefix ||= [shallow_path_prefix, path_segment, ":#{singular}_id"].compact.join("/")
      end
    end
  end
end
