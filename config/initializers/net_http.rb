if Rails.env.development? || Rails.env.production?
  module Net
    class HTTP < Protocol
      def request(req, body = nil, &block)  # :yield: +response+
        unless started?
          start {
            req['connection'] ||= 'close'
            return request(req, body, &block)
          }
        end
        if proxy_user()
          unless use_ssl?
            req.proxy_basic_auth proxy_user(), proxy_pass()
          end
        end

        req.set_body_internal body
        begin_transport req
          req.exec @socket, @curr_http_version, edit_path(req.path)
          begin
            res = HTTPResponse.read_new(@socket)
          end while res.kind_of?(HTTPContinue)
          res.reading_body(@socket, req.response_body_permitted?) {
            yield res if block_given?
          }
        end_transport req, res

        res
      rescue => exception
        D "Conn close because of error #{exception}"
        @socket.close if @socket && !@socket.closed?
        raise exception
      end
    end
  end
end