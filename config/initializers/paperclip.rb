require 'paperclip/geometry'

module Paperclip
  class Geometry
    # Throw a couple of retries into Geometry.from_file to solve intermittent failures and keep me sane
    def self.from_file file
      retry_count = 0
      begin
        if retry_count > 0
          Rails.logger.info "Paperclip::Geometry.from_file: retrying #{retry_count} for #{file}" 
        end
        file = file.path if file.respond_to? "path"
        geometry = begin
                     Paperclip.run("identify", "-format", "%wx%h", "#{file}[0]")
                   rescue Cocaine::CommandLineError
                     ""
                   end
        parse(geometry) ||
          raise(NotIdentifiedByImageMagickError.new("#{file} is not recognized by the 'identify' command."))
      rescue => e
        if e.is_a?(NotIdentifiedByImageMagickError) && retry_count < 3
          retry_count += 1
          retry
        else
          raise
        end
      end
    end
  end
end
