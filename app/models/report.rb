class Report < ActiveRecord::Base
  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user

  searchable do
    text :name, :description
    text :username do
      user.username
    end
  end

  class << self
    def per_page
      10
    end

    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:page], :per_page => Report.per_page
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
    politician_scores = bill_criteria.active.map(&:scores).flatten.group_by(&:politician)
    politician_scores.inject({}) do |result_scores, (politician, bill_scores)|
      scores = bill_scores.map(&:score)
      result_scores[politician] = scores.sum / scores.size
      result_scores
    end.to_a.sort_by(&:last).reverse
  end
end
