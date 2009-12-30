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

  validates_presence_of :bill_type, :congress, :gov_track_id, :opencongress_id
  validates_uniqueness_of :gov_track_id, :opencongress_id
  validates_format_of :gov_track_id, :with => /[a-z]+\d\d\d-\d+/
  validates_format_of :opencongress_id, :with => /\d\d\d-[a-z]+\d+/

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

  def congress=(congress)
    if !new_record? && self.congress && congress != self.congress
      raise ActiveRecord::ReadOnlyRecord, "Can't change bill congress"
    end
    self[:congress_id] = congress.id
  end

  def bill_type=(bill_type)
    if !new_record? && self.bill_type && bill_type != self.bill_type
      raise ActiveRecord::ReadOnlyRecord, "Can't change bill type"
    end
    self[:bill_type] = bill_type
  end

  def bill_number=(bill_number)
    if !new_record? && self.bill_number && bill_number != self.bill_number
      raise ActiveRecord::ReadOnlyRecord, "Can't change bill number"
    end
    self[:bill_number] = bill_number
  end
end
