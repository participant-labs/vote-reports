class Bill < ActiveRecord::Base
  PER_PAGE = 30

  named_scope :recent, :limit => 25, :order => 'created_at DESC'

  has_friendly_id :opencongress_id

  searchable do
    text :title, :summary, :gov_track_id, :opencongress_id
    integer :bill_number
    time :introduced_on
  end

  belongs_to :congress
  belongs_to :sponsor, :class_name => 'Politician'

  has_many :bill_criteria
  has_many :amendments, :dependent => :destroy
  has_many :rolls, :as => :subject, :dependent => :destroy
  has_many :votes, :through => :rolls
  def politicians
    Politician.scoped(:joins => {:votes => :roll}, :conditions => {
      :'rolls.subject_id' => self, :'rolls.subject_type' => 'Bill'
    }).extend(Vote::Support)
  end

  validates_presence_of :bill_type, :congress, :gov_track_id
  validates_uniqueness_of :gov_track_id
  validates_uniqueness_of :opencongress_id, :allow_nil => true

  class << self
    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:page], :per_page => PER_PAGE
      end
    end
  end

  def bill_type
    self['bill_type'].gsub('.',' ').gsub('H Res','HR').gsub('H R','HR')
  end

  def title_with_number
    "#{bill_type}: #{title}"
  end

  def opencongress_url
    "http://www.opencongress.org/bill/#{opencongress_id}/show"
  end

  def inspect
    %{#<Bill #{gov_track_id} - "#{title}">}
  end
end
