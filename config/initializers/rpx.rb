require 'authlogic_rpx' # This doesn't support rails 3 initialization as of yet, so require it here

begin
  require Rails.root.join('config/secure_variables')
rescue LoadError
end

class RPXIdentifier < ActiveRecord::Base
  belongs_to :user
end

RPX_API_KEY = ENV['RPX_API_KEY'] unless defined?(RPX_API_KEY)
RPX_APP_NAME = 'VoteReports'
