class Report < ActiveRecord::Base
  PER_PAGE = 10

  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user

  searchable do
    text :name, :description
    text :username do
      user.username
    end
  end

  class << self
    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:page], :per_page => PER_PAGE
      end
    end
  end

  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }

  validates_presence_of :user, :name

  named_scope :published, :select => 'DISTINCT reports.*', :joins => :bill_criteria
  named_scope :scored, :select => 'DISTINCT reports.*', :joins => {:bill_criteria => {:bill => :rolls}}
  named_scope :by_updated_at, :order => 'updated_at DESC'

  def description
    BlueCloth::new(self[:description].to_s).to_html
  end

  def generate_scores!
    all_scores = bill_criteria.inject(Hash.new(0.0)) do |scores, bill_criterion|
      votes = bill_criterion.bill.votes
      votes.each do |vote|
        scores[vote.politician] += bill_criterion.score(vote)
      end
      scores
    end
    all_scores.each_pair do |politician, score|
      total = bill_criteria.count
      all_scores[politician] = ((score + total)/(total * 2)) * 100
    end
    all_scores.to_a.sort_by(&:last).reverse
  end
end
