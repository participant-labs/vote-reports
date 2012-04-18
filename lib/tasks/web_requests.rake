namespace :web_requests do
  namespace :fixtures do
    task :generate do
      require 'open-uri'

      URLS = [
        "http://api.opencongress.org/bills_by_ident?key=#{ENV['OPEN_CONGRESS_API_KEY']}&ident=111-h3548&format=json",
        "http://api.opencongress.org/bills_by_query?key=#{ENV['OPEN_CONGRESS_API_KEY']}&q=Patriot+Act&format=json",
        "http://api.opencongress.org/bills_by_query?key=#{ENV['OPEN_CONGRESS_API_KEY']}&q=smelly+roses&format=json"
      ]

      responses = URLS.map do |url|
        begin
          [:get, url, {body: open(url).read}]
        rescue OpenURI::HTTPError
        end
      end.compact

      Marshal.dump(responses, open(Rails.root.join('spec/fixtures/web_requests.marshal'), 'w'))
    end
  end
end