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
  has_many :cosponsorships
  has_many :cosponsors, :through => :cosponsorships, :source => :politician

  has_many :bill_subjects
  has_many :subjects, :through => :bill_subjects

  has_many :bill_titles
  has_many :bill_criteria
  has_many :amendments, :dependent => :destroy
  has_many :rolls, :as => :subject, :dependent => :destroy
  has_many :votes, :through => :rolls
  def politicians
    Politician.scoped(:select => 'DISTINCT politicians.*', :joins => {:votes => :roll}, :conditions => {
      :'rolls.subject_id' => self, :'rolls.subject_type' => 'Bill'
    }).extend(Vote::Support)
  end

  composed_of :bill_type

  validates_presence_of :bill_type, :congress, :gov_track_id, :opencongress_id, :introduced_on
  validates_uniqueness_of :bill_number, :scope => [:congress_id, :bill_type]
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

  def title(type = :official)
    bill_titles.find(:first, :conditions => {:title_type => type.to_s})
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
    bill_type = bill_type.abbrev if bill_type.is_a?(BillType)
    if !new_record?
      if !BillType::TYPES.has_key?(self.bill_type.abbrev)
        puts "bill type #{self.bill_type} -> #{bill_type}"
      elsif bill_type != self.bill_type.abbrev
        raise ActiveRecord::ReadOnlyRecord, "Can't change bill type from #{self.bill_type} to #{bill_type}"
      end
    end
    super
  end

  def bill_number=(bill_number)
    if !new_record? && self.bill_number && bill_number.to_i != self.bill_number
      raise ActiveRecord::ReadOnlyRecord, "Can't change bill number"
    end
    self[:bill_number] = bill_number
  end
end
