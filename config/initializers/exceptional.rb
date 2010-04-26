def notify_exceptional(exception)
  exception = RuntimeError.new(exception) unless exception.is_a?(Exception)
  Rails.logger.error(exception.inspect)
  Exceptional.send(:catch, exception) if defined?(Exceptional)
  nil
rescue => e
  Rails.logger.error("Trouble (#{e.inspect}) Notifying Exceptional of #{exception.inspect}")
  nil
end
