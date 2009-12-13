def notify_exceptional(exception)
  Rails.logger.error(exception.inspect)
  Exceptional.catch(exception) if defined?(Exceptional)
  nil
rescue
  Rails.logger.error("Trouble Notifying Exception of #{exception.inspect}")
  nil
end
