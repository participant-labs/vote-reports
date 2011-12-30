class Politician < ActiveRecord::Base
  include Politician::GovTrack
  include Politician::SunlightLabs

  extend FriendlyId
  friendly_id :full_name, use: :slugged

  has_many :candidacies
  has_many :races, through: :candidacies
  belongs_to :current_candidacy, class_name: 'Candidacy'

  def latest_candidacy
    candidacies.valid.first(joins: {race: :election_stage}, order: 'election_stages.voted_on DESC', conditions: ['election_stages.voted_on > ?', Date.today]) \
    || candidacies.valid.first(joins: {race: :election_stage}, order: 'election_stages.voted_on DESC')
  end

  has_many :committee_memberships
  has_many :committee_meetings, through: :committee_memberships

  has_many :representative_terms
  has_one :latest_representative_term, class_name: 'RepresentativeTerm', order: 'ended_on DESC'

  has_many :senate_terms
  has_one :latest_senate_term, class_name: 'SenateTerm', order: 'ended_on DESC'

  has_many :presidential_terms
  has_one :latest_presidential_term, class_name: 'PresidentialTerm', order: 'ended_on DESC'

  has_many :interest_group_ratings
  has_many :interest_group_reports, through: :interest_group_ratings
  def rating_interest_groups
    InterestGroup.select('DISTINCT interest_groups.*').joins(reports: :ratings)\
      .where(:'interest_group_ratings.politician_id' => self)
  end

  def latest_term
    [latest_senate_term,
      latest_presidential_term,
      latest_representative_term].compact.sort_by(&:ended_on).last
  end

  def terms
    (
      representative_terms.all(include: [:party, :congressional_district])  +
      senate_terms.all(include: [:party, :state]) +
      presidential_terms.all(include: :party)
    ).sort_by(&:ended_on).reverse
  end

  def continuous_terms
    cterms = ContinuousTerm.find_all_by_politician_id(id, order: [['ended_on', 'desc']])
    if cterms.empty? && terms.present?
      ContinuousTerm.regenerate_for(self)
      cterms = ContinuousTerm.find_all_by_politician_id(id, order: [['ended_on', 'desc']])
    end
    cterms
  end

  belongs_to :congressional_district
  belongs_to :state, class_name: 'UsState', foreign_key: :us_state_id
  def location
    congressional_district || state
  end
  def location_abbreviation
    if congressional_district
      "#{state.abbreviation}-#{congressional_district.district_abbreviation}"
    elsif state
      state.abbreviation
    end
  end

  searchable do
    text :name
    boolean :autocompletable do
      in_office?
    end
    boolean :visible do
      true
    end
    boolean :in_office do
      in_office?
    end
  end

  class << self
    def paginated_search(params)
      search do
        fulltext params[:term]
        if params[:except].present?
          without(params[:except])
        end
        paginate page: params[:page]
      end
    end
  end

  IDENTITY_STRING_FIELDS = [
    :vote_smart_id, :bioguide_id, :eventful_id, :twitter_id, :email, :metavid_id,
    :congresspedia_url, :open_secrets_id, :fec_id, :phone, :website, :youtube_url, :facebook_id
  ].freeze
  IDENTITY_INTEGER_FIELDS = [:gov_track_id].freeze
  IDENTITY_FIELDS = (IDENTITY_STRING_FIELDS | IDENTITY_INTEGER_FIELDS).freeze

  validates_length_of IDENTITY_STRING_FIELDS, minimum: 1, allow_nil: true
  validates_uniqueness_of IDENTITY_FIELDS, allow_nil: true

  validate :name_shouldnt_contain_nickname
  before_validation :extract_nickname_from_first_name_if_present

  has_many :votes
  has_many :rolls, through: :votes, extend: Vote::Support

  has_many :report_scores
  has_many :reports, through: :report_scores

  belongs_to :current_office, polymorphic: true
  scope :by_prominance, order('prominence')
  scope :in_office, where('politicians.current_office_id IS NOT NULL')
  scope :in_office_normal_form, lambda {
    select('DISTINCT politicians.*')\
    .joins([
      %{LEFT OUTER JOIN "representative_terms" ON representative_terms.politician_id = politicians.id},
      %{LEFT OUTER JOIN "senate_terms" ON senate_terms.politician_id = politicians.id},
      %{LEFT OUTER JOIN "presidential_terms" ON presidential_terms.politician_id = politicians.id}])\
    .where([
      '(((representative_terms.started_on, representative_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))) OR ' \
      '((senate_terms.started_on, senate_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))) OR ' \
      '((presidential_terms.started_on, presidential_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))))',
      {yesterday: Date.yesterday, tomorrow: Date.tomorrow}
    ])
  }

  scope :has_current_candidacy, select('DISTINCT politicians.*').joins(:candidacies).where(['candidacies.status NOT IN(?)', ["Deceased", "Withdrawn", "Removed"]])

  scope :scoreworthy, where('politicians.current_office_id IS NOT NULL OR politicians.current_candidacy_id IS NOT NULL')

  class << self
    def prominence_clause
      %{
        politicians.*,
        CASE
          WHEN politicians.current_office_type='PresidentialTerm' THEN 1
          WHEN politicians.current_office_type='SenateTerm' THEN 2
          WHEN politicians.current_office_type='RepresentativeTerm' THEN 3
          ELSE 7
        END AS prominence
      }
    end

    def update_current_office_status!(opts = {})
      transaction do
        update_all(current_office_id: nil, current_office_type: nil)
        in_office_normal_form.find_each do |politician|
          politician.update_attribute(:current_office, politician.latest_term)
          print '.' unless opts[:quiet]
        end
      end
      puts unless opts[:quiet]
    end

    def update_current_candidacy_status!
      transaction do
        update_all(current_candidacy_id: nil)
        has_current_candidacy.find_each do |politician|
          politician.update_attribute(:current_candidacy, politician.latest_candidacy)
          print '.'
        end
      end
      puts
    end
  end
  def in_office?
    !current_office_id.nil?
  end

  scope :senators, where(current_office_type: 'SenateTerm')
  scope :representatives, where(current_office_type: 'RepresentativeTerm')
  scope :presidents, where(current_office_type: 'PresidentialTerm')

  scope :none, where('0 = 1')
  scope :for_display, includes([:state, :congressional_district])

  scope :with_name, lambda {|name|
    first, last = name.split(' ', 2)
    where(first_name: first, last_name: last)
  }
  scope :by_birth_date, order('birthday DESC NULLS LAST')
  scope :from_congressional_district, lambda {|districts|
    if districts.present?
      where([
        "senate_terms.us_state_id IN(?) OR representative_terms.congressional_district_id IN(?) OR presidential_terms.id IS NOT NULL",
         Array(districts).map(&:us_state_id), districts
      ]).joins([
        %{LEFT OUTER JOIN "representative_terms" ON representative_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "senate_terms" ON senate_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "presidential_terms" ON presidential_terms.politician_id = politicians.id},
      ]).select('DISTINCT politicians.*')
    else
      where('0 = 1')
    end
  }
  scope :with_in_office_terms, where([
      '(((representative_terms.started_on, representative_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))) OR ' \
      '((senate_terms.started_on, senate_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))) OR ' \
      '((presidential_terms.started_on, presidential_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))))',
      {yesterday: Date.yesterday, tomorrow: Date.tomorrow}
  ])

  scope :from_state, lambda {|state|
    state = UsState.first(conditions: ["abbreviation = :state OR UPPER(full_name) = :state", {state: state.upcase}]) if state.is_a?(String)
    if state
      select('DISTINCT politicians.*').where([
        'senate_terms.us_state_id = ? OR congressional_districts.us_state_id = ? OR presidential_terms.id IS NOT NULL', state, state
      ]).joins([
        %{LEFT OUTER JOIN "representative_terms" ON representative_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "senate_terms" ON senate_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "presidential_terms" ON presidential_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "congressional_districts" ON representative_terms.congressional_district_id = congressional_districts.id},
      ])
    else
      where('0 = 1')
    end
  }
  scope :representatives_from_state, lambda {|state|
    state = UsState.where(["abbreviation = :state OR UPPER(full_name) = :state", {state: state.upcase}]).first if state.is_a?(String)
    if state
      select('DISTINCT politicians.*').where(['congressional_districts.us_state_id = ?', state])\
        .joins(representative_terms: :congressional_district)
    else
      where('0 = 1')
    end
  }

  class << self
    def for_districts(districts)
      from_congressional_district(districts.map(&:congressional_district).compact)
    end

    def from_zip_code(zip_code)
      from_congressional_district(CongressionalDistrict.with_zip(zip_code))
    end

    def from_city(address)
      from_congressional_district(CongressionalDistrict.for_city(address))
    end

    def from_location(geoloc)
      if geoloc.respond_to?(:precision)
        case geoloc.precision
        when 'country'
          if geoloc.is_us?
            Politician
          else
            Politician.none
          end
        when 'state'
          from_state(geoloc.state)
        when 'zip', 'zip+4'
          from_zip_code(geoloc.zip)
        when 'city'
          from_city("#{geoloc.city}, #{geoloc.state}")
        else # %w{street address building}
          for_districts(District.lookup(geoloc))
        end
      else
        from_city("#{geoloc.city}, #{geoloc.state}")
      end
    end

    def from(representing)
      if representing.blank?
        self
      elsif representing.is_a?(Geokit::GeoLoc)
        from_location(representing)
      else
        results = from_zip_code(representing)
        # try state first as it's much more restrictive search than city
        # and there are some misleading 2-character cities
        results = from_state(representing) if results.blank?
        results = from_city(representing) if results.blank?
        results = from_location(Geokit::Geocoders::MultiGeocoder.geocode(representing)) if results.blank?
        results
      end
    end
  end

  def prominence
    case current_office_type
    when 'PresidentialTerm'
      1
    when 'SenateTerm'
      2
    when 'RepresentativeTerm'
      3
    else
      4
    end
  end

  has_many :sponsorships, class_name: 'Cosponsorship'
  has_many :bills_sponsored, through: :sponsorships, source: :bill

  def full_name= full_name
    self.last_name, self.first_name = full_name.split(', ', 2)
  end

  def full_name
    [first_name, last_name].join(" ")
  end
  alias_method :name, :full_name

  class << self
    def update_titles!
      find_each do |politician|
        title = politician.latest_term.try(:title)
        if politician.title != title
          politician.update_attribute(:title, title)
        end
      end
    end
  end
  def short_title
    return '' if title.blank?
    if title == 'President'
      'Pres.'
    else
      "#{title.to(2)}."
    end
  end

  def merge!(politician)
    transaction do
      politician.candidacies.update_all(politician_id: id)
      politician.representative_terms.update_all(politician_id: id)
      politician.senate_terms.update_all(politician_id: id)
      politician.presidential_terms.update_all(politician_id: id)
      politician.interest_group_ratings.update_all(politician_id: id)
      politician.votes.update_all(politician_id: id)
      politician.report_scores.update_all(politician_id: id)
      politician.committee_memberships.update_all(politician_id: id)
      politician.slugs.update_all(sluggable_id: id, created_at: 1.year.ago)
      politician.cosponsorships.update_all(politician_id: id)
      attributes.each do |attribute, value|
        merge_value = politician.attributes[attribute]
        if IDENTITY_FIELDS.include?(attribute.to_sym) && value && merge_value && value != merge_value
          raise "Unmatched ids for #{attribute}: #{value}, #{merge_value}"
        end
        if attribute == 'slug' && value.match(/--\d/) && !merge_value.match(/--\d/)
          value = politician.attributes[attribute]
        end
        send(:"#{attribute}=", value || merge_value)
      end
      politician.delete
      save!
    end
  end

  private

  def normalize_friendly_id(text)
    text.to_slug.normalize!
  end

  def name_shouldnt_contain_nickname
    errors.add(:first_name, "shouldn't contain nickname") if first_name =~ /\s?(.+)\s'(.+)'\s?/
  end

  def extract_nickname_from_first_name_if_present
    if first_name =~ /\s?(.+)\s'(.+)'\s?/
      self.first_name = $1
      self.nickname = $2
    end
  end
end
