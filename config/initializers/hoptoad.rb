def notify_hoptoad(exception)
  exception = RuntimeError.new(exception) unless exception.is_a?(Exception)
  Rails.logger.error(exception.inspect)
  HoptoadNotifier.notify_or_ignore(exception) if defined?(HoptoadNotifier)
  nil
rescue => e
  Rails.logger.error("Trouble (#{e.inspect}) Notifying Hoptoad of #{exception.inspect}")
  raise unless Rails.env.production?
  nil
end
