def notify(exception)
  Rails.logger.error(exception.inspect)
  Exceptional.catch(exception) if defined?(Exceptional)
end
