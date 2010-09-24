class ReportScore < ActiveRecord::Base
  include Score

  belongs_to :report
  belongs_to :politician
  has_many :evidence, :class_name => 'ReportScoreEvidence', :dependent => :destroy

  default_scope :order => 'score DESC'
  named_scope :bottom, :order => :score

  alias_method :subject, :report # for the score evidence pop-up

  named_scope :with_evidence, :include => [
    {:politician => :state},
    :evidence
  ]

  named_scope :with, :conditions => "report_scores.score > 66.667"
  named_scope :against, :conditions => "report_scores.score < 33.333"
  named_scope :neutral, :conditions => "report_scores.score BETWEEN 33.333 AND 66.667"
  class << self
    def votes_how(how)
      send(how.to_sym)
    end
  end

  has_many :dependent_report_score_evidences, :class_name => 'ReportScoreEvidence', :as => :evidence
  has_many :dependent_report_scores, :class_name => 'ReportScore',
    :through => :dependent_report_score_evidences, :source => :score

  named_scope :for_politician_display, :include => {:report => [:cause, {:interest_group => :image}, :user, :top_subject]}
  named_scope :for_report_display, :include => {:politician => [:state, :congressional_district]}

  named_scope :published, :joins => :report, :conditions => [
    "reports.state = ? OR reports.user_id IS NULL", 'published']

  named_scope :for_causes, :joins => :report, :conditions => ['reports.cause_id IS NOT NULL']
  named_scope :for_published_reports, :joins => :report, :conditions => [
    "(reports.state = ? OR reports.user_id IS NULL) AND reports.cause_id IS NULL", 'published']

  named_scope :for_reports_with_subjects, lambda {|subjects|
    subjects = Array(subjects)
    if subjects.empty?
      {}
    else
      {
        :select => 'DISTINCT report_scores.*',
        :joins => {:report => :subjects},
        :conditions => (subjects.first.is_a?(String) \
         ? ["subjects.name IN(?) OR subjects.cached_slug IN(?)", subjects, subjects] \
         : ['subjects.id IN(?)', subjects])
      }
    end
  }

  named_scope :for_politicians, lambda {|politicians|
    politicians = Array(politicians)
    if politicians.empty? || politicians.first == Politician
      {}
    else
      {:conditions => {:politician_id => politicians}}
    end
  }

  named_scope :for_reports, lambda {|reports|
    reports = Array(reports)
    if reports.empty?
      {}
    else
      {:conditions => {:report_id => reports}}
    end
  }

  class << self
    def per_page
      12
    end
  end

  before_destroy :rescore_dependent_reports

  def to_s
    letter_grade
  end

  def event_date
    Date.today
  end

  def as_json(opts = {})
    super(opts.reverse_merge(:only => [:evidence_description, :gov_track_id, :vote_smart_id, :score, :name, :id], :include => [:politician, :report]))
  end

  private

  def rescore_dependent_reports
    dependent_report_scores.each do |dependent_score|
      dependent_score.report.rescore!
      dependent_score.destroy
    end
  end
end
