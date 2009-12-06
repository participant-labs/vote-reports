class Vote < ActiveRecord::Base

  belongs_to :politician
  belongs_to :bill

  class << self
    def fetch_for_bill(bill)
      vs_bill_id = VoteSmart::Vote.get_bill_by_bill_number(bill.bill_type)['bills']['bill'][0]['billId']
      vs_actions = VoteSmart::Vote.get_bill(vs_bill_id)['bill']['actions']
      vs_action_id = vs_actions['action'].find{|a| a['stage'] == 'Passage' }['actionId']
      votes = VoteSmart::Vote.get_bill_action_votes(vs_action_id)['votes']['vote']

      votes.map do |vote|
        politician = Politician.find_by_vote_smart_id(vote['candidateId'])
        politician ||= Politician.create(:full_name => vote['candidateName'], :vote_smart_id => vote['candidateId'])
        politician.votes.find_by_bill_id(bill.id) ||
          politician.votes.create(:bill_id => bill.id, :vote => bool_action(vote))
      end
    rescue => e
      notify_exceptional(e)
      []
    end

    def bool_action(vote)
      vote['action'] == 'Yea'
    end
  end

end
