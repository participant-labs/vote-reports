class Bill < ActiveRecord::Base
  default_scope :include => {:titles => :as}
  named_scope :by_introduced_on, :order => 'introduced_on DESC'
  named_scope :with_title, lambda {|title|
    {:select => 'DISTINCT bills.*', :joins => :titles, :conditions => {:'bill_titles.title' => title}}
  }

  has_friendly_id :opencongress_id

  belongs_to :congress

  belongs_to :sponsor, :class_name => 'Politician'
  has_many :cosponsorships
  has_many :cosponsors, :through => :cosponsorships, :source => :politician

  has_many :bill_subjects
  has_many :subjects, :through => :bill_subjects

  has_many :committee_actions, :class_name => 'BillCommitteeActions'
  has_many :committees, :through => :committee_actions

  has_many :titles, :class_name => 'BillTitle'
  has_many :bill_criteria, :dependent => :destroy
  has_many :reports, :through => :bill_criteria
  has_many :amendments, :dependent => :destroy
  has_many :rolls, :as => :subject, :dependent => :destroy
  has_many :passage_rolls, :as => :subject, :class_name => 'Roll', :conditions => [
    "rolls.roll_type IN(?)", Roll::PASSAGE_TYPES
  ]
  has_many :votes, :through => :rolls
  def politicians
    Politician.scoped(:select => 'DISTINCT politicians.*', :joins => {:votes => :roll}, :conditions => {
      :'rolls.subject_id' => self, :'rolls.subject_type' => 'Bill'
    }).extend(Vote::Support)
  end

  composed_of :bill_type

  define_index do
    indexes summary
    indexes gov_track_id
    indexes opencongress_id
    indexes bill_number
    intexes subjects(:name), :as => :subjects
    indexes titles(:title), :as => :title
    indexes introduced_on
    indexes bill_number

    # boolean :current do
    #   congress.current?
    # end
    # boolean :voted do
    #   voted?
    # end
  end

  validates_format_of :gov_track_id, :with => /[a-z]+\d\d\d-\d+/
  validates_format_of :opencongress_id, :with => /\d\d\d-[a-z]+\d+/

  class << self
    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:page], :per_page => Bill.per_page
        if params[:voted]
          without :voted, false
        end
        if params[:current]
          without :current, false
        end
      end
    end
  end

  def opencongress_url
    # As of the 111th, OpenCongress only maintains pages for bills for the current meeting
    "http://www.opencongress.org/bill/#{opencongress_id}/show" if congress.current?
  end

  def inspect
    %{#<Bill #{gov_track_id} - "#{titles.first}">}
  end

  def ref
    "#{bill_type}#{bill_number}"
  end

  def voted?
    passage_rolls.present?
  end

  def old_and_unvoted?
    !congress.current? & !voted?
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
