def notify_exceptional(exception)
  Rails.logger.error(exception.inspect)
  Exceptional.catch(exception) if defined?(Exceptional)
end
