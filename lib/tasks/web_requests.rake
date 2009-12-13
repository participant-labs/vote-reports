namespace :web_requests do
  namespace :fixtures do
    task :generate do
      require 'open-uri'

      URLS = [
        "http://www.opencongress.org/api/bills_by_ident?key=#{ENV['OPEN_CONGRESS_API_KEY']}&ident=111-h3548&format=json",
        "http://www.opencongress.org/api/bills_by_query?key=#{ENV['OPEN_CONGRESS_API_KEY']}&q=Patriot+Act&format=json",
        "http://www.opencongress.org/api/bills_by_query?key=#{ENV['OPEN_CONGRESS_API_KEY']}&q=smelly+roses&format=json"
        # "http://api.votesmart.org/Votes.getByBillNumber?key=#{ENV['PVS_API_KEY']}&o=JSON&billNumber=HR+3548",
        # "http://api.votesmart.org/Votes.getByBillNumber?key=#{ENV['PVS_API_KEY']}&o=JSON&billNumber=HR+856",
        # "http://api.votesmart.org/Votes.getByBillNumber?key=#{ENV['PVS_API_KEY']}&o=JSON&billNumber=S+1692",
        # "http://api.votesmart.org/Votes.getByBillNumber?key=#{ENV['PVS_API_KEY']}&o=JSON&billNumber=HR+1209",
        # "http://api.votesmart.org/Votes.getBill?key=#{ENV['PVS_API_KEY']}&o=JSON&billId=10289",
        # "http://api.votesmart.org/Votes.getBill?key=#{ENV['PVS_API_KEY']}&o=JSON&billId=2928",
        # "http://api.votesmart.org/Votes.getBillActionVotes?key=#{ENV['PVS_API_KEY']}&o=JSON&actionId=28181",
        # "http://api.votesmart.org/Votes.getBillActionVotes?key=#{ENV['PVS_API_KEY']}&o=JSON&actionId=8222"
      ]

      responses = URLS.map do |url|
        [:get, url, {:body => open(url).read}]
      end

      Marshal.dump(responses, open(Rails.root.join('spec/support/web_requests.marshal'), 'w'))
    end
  end
end