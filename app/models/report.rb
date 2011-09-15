class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :interest_group
  belongs_to :cause
  has_one :guide
  def owner
    user || interest_group || cause || guide
  end

  belongs_to :image
  # this is a hack, to be fixed by separating out UserReports
  def current_image
    image || (owner && owner.respond_to?(:image) && owner.image) || (laws_i_like? && Image.laws_i_like)
  end
  def thumbnail
    current_image || build_image
  end

  has_friendly_id :name, :use_slug => true, scope: :user

  has_many :report_delayed_jobs
  has_many :delayed_jobs, through: :report_delayed_jobs do
    def failing
      where('delayed_jobs.last_error IS NOT NULL')
    end

    def passing
      where(last_error: nil)
    end

    def unlocked
      where(locked_at: nil)
    end
  end

  has_many :report_subjects
  has_many :subjects, through: :report_subjects
  belongs_to :top_subject, :class_name => 'Subject'

  scope :for_display, includes([:top_subject, :image, :cause, :user, :interest_group])

  def bill_criteria_subjects
    Subject.for_bill_criteria_on_report(self)
  end

  def publish_step
    if bill_criteria.blank?
      "You'll need to add bills to this report in order to publish it."
    elsif scores.blank?
      "None of this report's bills have roll call votes associated. You'll need to add a voted bill to publish this report."
    else
      {
        text: 'Publish this Report',
        why: "Publishing this report will include it in lists and searches on the site",
        :state_event => 'publish',
        confirm: 'Publish this Report?  It will then show up in lists and searches on this site.'
      }
    end
  end

  def share_step
    {
      text: 'Share this Report',
      why: "Sharing this report will allow others to access it from this url.",
      :state_event => 'share',
      confirm: 'Share this Report?  It will accessible to others via this url.'
    }
  end

  def unshare_step
    {
      text: 'Unshare this Report',
      why: "Unsharing this report will make it accessible only to you.",
      :state_event => 'unshare',
      confirm: 'Unshare this Report? It will only be accesible to you.'
    }
  end

  def unlist_step
    {
      text: 'Unlist this Report',
      why: "Unlisting this report will remove it from lists & searches on the site.",
      :state_event => 'unlist',
      confirm: 'Unlist this Report? It will no longer show up in lists and searches on this site.'
    }
  end

  state_machine initial: :private do
    event :publish do
      transition [:private, :unlisted] => :published
    end

    event :share do
      transition [:private, :published] => :unlisted
    end

    event :unshare do
      transition [:published, :unlisted] => :private
    end

    event :unlist do
      transition published: :unlisted
    end

    state :personal

    state :private do
      def status
        "This report is private, so only you can access it."
      end

      def next_steps
        if publish_step.is_a?(String)
          [
            share_step,
            publish_step
          ]
        else
          [
            publish_step,
            share_step
          ]
        end
      end
    end

    state :unlisted do
      def status
        "This report is unlisted, so it will not show up in lists or searches on this site. However, anyone can access it at this url."
      end

      def next_steps
        [
          publish_step,
          unshare_step
        ]
      end
    end

    state :published do
      validates_presence_of :bill_criteria
      validates_presence_of :scores

      def status
        "This report is published, so it will show up in lists and searches on this site."
      end

      def next_steps
        [
          unlist_step
        ]
      end
    end
  end

  def next_step
    next_steps.first
  end

  searchable do
    text :name, :description
    text :username do
      user.try(:username)
    end
    boolean :visible do
      user.nil? || published?
    end
    boolean :autocompletable do
      user.nil? || published?
    end
  end

  paginates_per 10

  class << self
    def paginated_search(params)
      search do
        fulltext params[:term]
        with(:visible, true)
        if params[:except].present?
          without(params[:except])
        end
        paginate page: params[:page], :per_page => Report.default_per_page
      end
    end
  end

  has_many :cause_reports, dependent: :destroy
  has_many :causes, through: :cause_reports

  has_many :bill_criteria, dependent: :destroy do
    def active_count
      # due to an apparent bug in rails, the joins are not distincting, so this is necessary
      active.count(distinct: true, select: 'bill_criteria.*')
    end

    def autofetch_from!(url)
      BillCriterion.autofetch_from(url).map do |(bill_title, attrs)|
        if bill = Bill.guess(bill_title)
          find_by_bill_id(bill) || build(attrs.merge(bill: bill))
        elsif Rails.env.production?
          notify_hoptoad("No bill found for autofetch #{bill_title} from #{url}")
        end
      end.compact.index_by(&:bill).values
    end
  end
  has_many :bills, through: :bill_criteria

  has_many :amendment_criteria, dependent: :destroy

  def has_criteria?
    bill_criteria.present? || amendment_criteria.present?
  end

  has_many :follows, :class_name => 'ReportFollow', dependent: :destroy
  has_many :followers, through: :follows, source: :user

  has_many :scores, :class_name => 'ReportScore', dependent: :destroy

  validate :name_not_reserved

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }
  accepts_nested_attributes_for :amendment_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }

  validates_presence_of :name
  validate :ensure_only_one_owner
  before_validation :add_creator_to_followers, on: :create

  before_create :ensure_state_is_set

  scope :random, order('random()')

  scope :laws_i_like, where(source: 'laws_i_like')
  scope :user_published, where(state: 'published').includes(:user)
  scope :for_causes, where('reports.cause_id IS NOT NULL')
  scope :non_cause, where('reports.cause_id IS NULL')
  scope :without_associated_cause, joins('LEFT OUTER JOIN cause_reports ON cause_reports.report_id = reports.id').where('cause_reports.cause_id IS NULL')
  scope :published, where(["reports.state = ? OR reports.user_id IS NULL", 'published'])\
    .includes([:user, :interest_group])

  class << self
    def qualified_column_names
      column_names.collect {|c| "reports.#{c}"}.join(",")
    end
  end

  scope :unpublished, where(["reports.state IN(?)", %w[unlisted private]])
  scope :except_personal, where(["reports.state != ?", 'personal'])
  scope :with_criteria, select('DISTINCT reports.*').joins(:bill_criteria)
  scope :scored, select('DISTINCT reports.*').joins(:bill_criteria => {bill: :passage_rolls})
  scope :by_updated_at, order('updated_at DESC')
  scope :by_created_at, order('created_at DESC')
  scope :by_name, order('name')

  scope :with_subjects, lambda {|subjects|
    subjects = Array(subjects)
    if subjects.empty?
      {}
    elsif subjects.first.is_a?(String)
      select('DISTINCT reports.*').joins(:subjects).where([
        "subjects.name IN(:subjects) OR subjects.cached_slug IN(:subjects)",
        {subjects: subjects}
      ])
    else
      select('DISTINCT reports.*').joins(:report_subjects).where(['report_subjects.subject_id IN(?)', subjects])
    end
  }

  scope :with_scores_for, lambda {|politicians|
    if politicians.blank?
      {}
    else
      joins(:scores).where(:'report_scores.politician_id' => politicians)\
        .group(qualified_column_names).having('COUNT(report_scores.id) > 0')
    end
  }

  def laws_i_like?
    source == 'laws_i_like'
  end

  def score_criteria
    if user
      if state == 'personal'
        user.report_follows
      else
        bill_criteria.active + amendment_criteria.active
      end
    else
      owner.score_criteria
    end
  end

  def name
    if self[:name].blank? && owner.respond_to?(:name)
      owner.name
    else
      self[:name]
    end
  end

  def description
    if self[:description].blank? && owner.respond_to?(:description)
      owner.description
    else
      self[:description]
    end
  end

  def rescore!
    unless delayed_jobs.unlocked.present? || (scores.blank? && score_criteria.blank?)
      delayed_jobs << ::Delayed::Job.enqueue(Report::Scorer.new(id))
    end
  end

  class << self
    def rescore!
      non_cause.find_each do |report|
        report.rescore!
      end
      for_causes.find_each do |report|
        report.rescore!
      end
    end
  end

  def interest_group=(ig)
    self.name ||= ig.name
    self.description ||= ig.description
    self[:interest_group_id] = ig.id
  end

  # include ActionController::UrlWriter
  # include ActionController::PolymorphicRoutes
  # def url
  #   path_components =
  #     if user
  #       [user, self]
  #     else
  #       owner || raise("No owner for report: #{inspect}")
  #     end
  #   polymorphic_url(path_components, host: 'votereports.org')
  # end

  def as_json(opts = {})
    super opts.reverse_merge(only: [:name, :description, :id], include: [:top_subject, :interest_group, :user, :cause], methods: [:to_param, :url])
  end

private

  def add_creator_to_followers
    if user && state != 'personal'
      self.followers << user
    end
  end

  def ensure_state_is_set
    self.state ||= 'Personal'
  end

  def ensure_only_one_owner
    if [user, interest_group, cause].compact.size > 1
      errors.add_to_base("Report can't have multiple owners")
    end
  end

  def name_not_reserved
    if %w[new edit].include?(name.to_s.downcase)
      errors.add(:name, "is reserved")
    end
  end
end
