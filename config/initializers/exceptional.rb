def notify_exceptional(exception)
  exception = RuntimeError.new(exception) unless exception.is_a?(Exception)
  Rails.logger.error(exception.inspect)
  Exceptional.handle(exception) if defined?(Exceptional)
  nil
rescue => e
  Rails.logger.error("Trouble (#{e.inspect}) Notifying Exceptional of #{exception.inspect}")
  raise unless Rails.env.production?
  nil
end
