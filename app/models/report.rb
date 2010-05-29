class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :interest_group
  belongs_to :cause
  def owner
    user || interest_group || cause
  end

  belongs_to :image
  def thumbnail
    image || interest_group.try(:image) || build_image
  end

  has_friendly_id :name, :use_slug => true, :scope => :user

  has_many :report_delayed_jobs
  has_many :delayed_jobs, :through => :report_delayed_jobs do
    def failing
      scoped(:conditions => 'delayed_jobs.last_error IS NOT NULL')
    end

    def passing
      scoped(:conditions => {:last_error => nil})
    end

    def unlocked
      scoped(:conditions => {:locked_at => nil})
    end
  end

  has_many :report_subjects
  has_many :subjects, :through => :report_subjects
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
        :text => 'Publish this Report',
        :why => "Publishing this report will include it in lists and searches on the site",
        :state_event => 'publish',
        :confirm => 'Publish this Report?  It will then show up in lists and searches on this site.'
      }
    end
  end

  def share_step
    {
      :text => 'Share this Report',
      :why => "Sharing this report will allow others to access it from this url.",
      :state_event => 'share',
      :confirm => 'Share this Report?  It will accessible to others via this url.'
    }
  end

  def unshare_step
    {
      :text => 'Unshare this Report',
      :why => "Unsharing this report will make it accessible only to you.",
      :state_event => 'unshare',
      :confirm => 'Unshare this Report? It will only be accesible to you.'
    }
  end

  def unlist_step
    {
      :text => 'Unlist this Report',
      :why => "Unlisting this report will remove it from lists & searches on the site.",
      :state_event => 'unlist',
      :confirm => 'Unlist this Report? It will no longer show up in lists and searches on this site.'
    }
  end

  state_machine :initial => :private do
    event :publish do
      transition [:private, :personal] => :published
    end

    event :share do
      transition [:private, :published] => :personal
    end

    event :unshare do
      transition [:published, :personal] => :private
    end

    event :unlist do
      transition :published => :personal
    end

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

    state :personal do
      def status
        "This report is personal, so it will not show up in lists or searches on this site. However, anyone can access it at this url."
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
    boolean :published do
      user.nil? || published?
    end
    boolean :user_published do
      published?
    end
  end

  class << self
    def per_page
      10
    end

    def paginated_search(params)
      search do
        fulltext params[:q]
        with(:published, true)
        paginate :page => params[:page], :per_page => Report.per_page
      end
    end
  end

  has_many :bill_criteria, :dependent => :destroy
  has_many :bills, :through => :bill_criteria

  has_many :scores, :class_name => 'ReportScore', :dependent => :destroy

  validate :name_not_reserved

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }

  validates_presence_of :owner, :name
  validate :ensure_only_one_owner

  named_scope :random, :order => 'random()'

  named_scope :user_published, :conditions => {:state => 'published'}, :include => :user
  named_scope :published,
    :conditions => ["reports.state = ? OR reports.user_id IS NULL", 'published'],
    :include => [:user, :interest_group]
  class << self
    def qualified_column_names
      column_names.collect {|c| "reports.#{c}"}.join(",")
    end
  end

  named_scope :unpublished, :conditions => "reports.state != 'published'"
  named_scope :with_criteria, :select => 'DISTINCT reports.*', :joins => :bill_criteria
  named_scope :scored, :select => 'DISTINCT reports.*', :joins => {:bill_criteria => {:bill => :passage_rolls}}
  named_scope :by_updated_at, :order => 'updated_at DESC'
  named_scope :by_created_at, :order => 'created_at DESC'
  named_scope :by_name, :order => 'name'

  named_scope :with_subjects, lambda {|subjects|
    subjects = Array(subjects)
    if subjects.empty?
      {}
    elsif subjects.first.is_a?(String)
      {
        :select => 'DISTINCT reports.*',
        :joins => :subjects,
        :conditions => ["subjects.name IN(:subjects) OR subjects.cached_slug IN(:subjects)",
          {:subjects => subjects}]
      }
    else
      {
        :select => 'DISTINCT reports.*',
        :joins => :report_subjects,
        :conditions => ['report_subjects.subject_id IN(?)', subjects]
      }
    end
  }

  named_scope :with_scores_for, lambda {|politicians|
    if politicians.blank?
      {}
    else
      {
        :select => 'DISTINCT reports.*, COUNT(report_scores.id) AS score_count',
        :joins => :scores,
        :conditions => {:'report_scores.politician_id' => politicians},
        :group => qualified_column_names,
        :order => 'score_count DESC'
      }
    end
  }

  def score_criteria
    if user
      bill_criteria.active
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
      BlueCloth::new(self[:description].to_s).to_html
    end
  end

  def rescore!
    unless delayed_jobs.unlocked.present?
      delayed_jobs << Delayed::Job.enqueue(Report::Scorer.new(id))
    end
  end

private

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
