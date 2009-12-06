def notify(exception)
  Rails.logger.error(exception.inspect)
  Exceptional::Api.catch(exception) if defined?(Exceptional::Api)
end
