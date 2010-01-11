class Report < ActiveRecord::Base
  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user

  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  accepts_nested_attributes_for :bill_criteria

  validates_presence_of :user, :name

  named_scope :published, :select => 'DISTINCT reports.*', :joins => :bill_criteria
  named_scope :recent, :limit => 10, :order => 'updated_at DESC'

  def description
    BlueCloth::new(self[:description].to_s).to_html
  end

  def generate_scores!
    all_scores = bill_criteria.inject({}) do |scores, bill_criterion|
      votes = bill_criterion.bill.votes
      votes.each do |vote|
        scores[vote.politician] ||= 0
        scores[vote.politician] += 1 if (bill_criterion.support? && vote.aye?) || (bill_criterion.oppose? && vote.nay?)
      end
      scores
    end
    all_scores.each_pair do |politician, score|
      all_scores[politician] = (score * 100) / bill_criteria.count
    end
    all_scores.to_a.sort_by(&:last).reverse
  end
end
