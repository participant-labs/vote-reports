class Report < ActiveRecord::Base
  belongs_to :user
  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  validates_presence_of :user_id
  validates_presence_of :name

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes|
    attributes['support'] == '0' && attributes['oppose'] == '0'
  }

  named_scope :recent, {
    :limit => 10, :order => 'updated_at DESC'
  }
  
  def generate_scores!
    all_scores = bill_criteria.inject({}) do |scores, bill_criterion|
      votes = bill_criterion.bill.votes
      votes.each do |vote|
        scores[vote.politician] ||= 0
        scores[vote.politician] += 1 if (bill_criterion.support && vote.vote) || (bill_criterion.oppose && !vote.vote)
      end
      scores
    end
    all_scores.each_pair do |politician, score|
      all_scores[politician] = (score * 100) / bill_criteria.count
    end
    all_scores.to_a.sort_by(&:last).reverse
  end
end
