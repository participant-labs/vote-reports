def notify_exceptional(exception)
  Rails.logger.error(exception.inspect)
  Exceptional.catch(exception) if defined?(Exceptional)
  nil
rescue => e
  Rails.logger.error("Trouble (#{e.inspect}) Notifying Exceptional of #{exception.inspect}")
  nil
end
