def notify(exception)
  Rails.logger.error(exception.inspect)
  Exceptional::Catcher.handle(exception) if defined?(Exceptional::Catcher)
end
