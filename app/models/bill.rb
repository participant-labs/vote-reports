class Bill < ActiveRecord::Base
  PER_PAGE = 30

  named_scope :recent, :limit => 25, :order => 'created_at DESC'

  has_friendly_id :opencongress_id

  searchable do
    text :summary, :gov_track_id, :opencongress_id
    text :bill_titles do
      bill_titles.map(&:title) * ' '
    end
    integer :bill_number
    boolean :old_and_unvoted do
      congress.meeting != Congress.current_meeting \
        && !Roll.exists?(:subject_id => self, :subject_type => self.class.name)
    end
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
  has_many :committee_actions, :class_name => 'BillCommitteeActions'
  has_many :committees, :through => :committee_actions
  has_many :amendments, :dependent => :destroy
  has_many :rolls, :as => :subject, :dependent => :destroy
  has_many :votes, :through => :rolls
  def politicians
    Politician.scoped(:select => 'DISTINCT politicians.*', :joins => {:votes => :roll}, :conditions => {
      :'rolls.subject_id' => self, :'rolls.subject_type' => 'Bill'
    }).extend(Vote::Support)
  end

  composed_of :bill_type

  validates_format_of :gov_track_id, :with => /[a-z]+\d\d\d-\d+/
  validates_format_of :opencongress_id, :with => /\d\d\d-[a-z]+\d+/

  class << self
    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:page], :per_page => PER_PAGE
        if params[:exclude_old_and_unvoted]
          without :old_and_unvoted, true
        end
      end
    end
  end

  def title(type = :official)
    bill_titles.find(:first, :conditions => {:title_type => type.to_s})
  end

  def opencongress_url
    # As of the 111th, OpenCongress only maintains pages for bills for the current meeting
    "http://www.opencongress.org/bill/#{opencongress_id}/show" if congress.current?
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
    if !new_record? && self[:bill_type] && BillType.valid_types.include?(self.bill_type) && bill_type != self.bill_type
      raise ActiveRecord::ReadOnlyRecord, "Can't change bill type from #{self.bill_type} to #{bill_type}"
    end
    self[:bill_type] = bill_type
  end

  def bill_number=(bill_number)
    if !new_record? && self[:bill_number] && bill_number.to_i != self[:bill_number]
      raise ActiveRecord::ReadOnlyRecord, "Can't change bill number"
    end
    self[:bill_number] = bill_number
  end
end
