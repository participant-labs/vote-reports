class Bill < ActiveRecord::Base
  extend FriendlyId
  friendly_id :opencongress_id

  default_scope include: {titles: :as}
  scope :by_introduced_on, order: 'introduced_on DESC'
  scope :with_title, lambda {|title|
    select('DISTINCT bills.*').joins(:titles).where(:'bill_titles.title' => title)
  }

  ROLL_PASSAGE_TYPES = [
    "On Passage", "Passage, Objections of the President Notwithstanding", "On Agreeing to the Resolution", "On Agreeing to the Resolution, as Amended", "On Motion to Suspend the Rules and Agree", "On Motion to Suspend the Rules and Agree, as Amended", "On Motion to Suspend the Rules and Pass", "On Motion to Suspend the Rules and Pass, as Amended", "On the Cloture Motion", "On Cloture on the Motion to Proceed",
  ]

  searchable do
    text :summary, :gov_track_id, :opencongress_id, :bill_number
    text :subjects do
      subjects.map(&:name) * ' '
    end
    text :bill_type do
      [bill_type.short_name, bill_type.long_name].join(' ')
    end
    text :titles do
      titles.map(&:title) * ' '
    end
    text :introduced_on do
      introduced_on.to_s(:long)
    end
    boolean :current do
      congress.current?
    end
    boolean :voted do
      voted?
    end
    integer :bill_number
    time :introduced_on
  end

  class << self
    def solr_reindex(opts = {})
      super(opts.reverse_merge(include: [:titles, :rolls, :congress, :subjects]))
    end

    def paginated_search(params)
      search do
        fulltext params[:term]
        paginate page: params[:page], per_page: Bill.default_per_page
        if params[:voted]
          without :voted, false
        end
        if params[:current]
          without :current, false
        end
        if params[:bill_number]
          with :bill_number, params[:bill_number]
        end
      end
    end

    def guess(info)
      number, name = info.split(' - ')
      house, bill_number = number.split(' ')
      paginated_search(term: "#{house} #{name}", bill_number: bill_number).results.first || begin
        words = name.split(' ')
        count = words.size / 2
        while count > 1
          comb = words.first(count).join(' ')
          if result = paginated_search(term: "#{house} #{comb}", bill_number: bill_number, current: true).results.first
            return result
          end
          count /= 2
        end
        paginated_search(term: house, bill_number: bill_number, current: true).results.first
      end
    end
  end

  belongs_to :congress

  belongs_to :sponsorship, class_name: 'Cosponsorship'
  has_one :sponsor, through: :sponsorship, source: :politician
  has_many :sponsorships, class_name: 'Cosponsorship'
  has_many :sponsors, through: :sponsorships, source: :politician

  def cosponsorships
    sponsorships.where(['cosponsorships.id != ?', sponsorship_id])
  end

  def cosponsors
    Politician.joins(:sponsorships).where(
      ["cosponsorships.bill_id = ? AND cosponsorships.id != ?", id, sponsorship_id]
    )
  end

  has_many :bill_subjects
  has_many :subjects, through: :bill_subjects

  has_many :committee_actions, class_name: 'BillCommitteeActions'
  has_many :committees, through: :committee_actions

  has_many :titles, class_name: 'BillTitle'
  has_many :bill_criteria, dependent: :destroy
  has_many :reports, through: :bill_criteria
  has_many :amendments, dependent: :destroy
  has_many :rolls, as: :subject, dependent: :destroy
  has_many :passage_rolls, as: :subject, class_name: 'Roll', conditions: {roll_type: ROLL_PASSAGE_TYPES}
  has_many :votes, through: :rolls
  has_many :passage_votes, through: :passage_rolls, source: :votes
  def politicians
    Politician.select('DISTINCT politicians.*').joins(votes: :roll).where(
      :'rolls.subject_id' => self, :'rolls.subject_type' => 'Bill'
    ).extend(Vote::Support)
  end

  composed_of :bill_type

  validates_format_of :gov_track_id, with: /[a-z]+\d\d\d-\d+/
  validates_format_of :opencongress_id, with: /\d\d\d-[a-z]+\d+/

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
