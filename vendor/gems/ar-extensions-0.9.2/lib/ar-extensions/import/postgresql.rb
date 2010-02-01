module ActiveRecord::Extensions::ConnectionAdapters::PostgreSQLAdapter # :nodoc:
  include ActiveRecord::Extensions::Import::ImportSupport
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
  include ActiveRecord::Extensions::ConnectionAdapters::PostgreSQLAdapter
end
