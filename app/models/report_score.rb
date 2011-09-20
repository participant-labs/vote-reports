class ReportScore < ActiveRecord::Base
  include Score

  belongs_to :report
  belongs_to :politician
  has_many :evidence, class_name: 'ReportScoreEvidence', dependent: :destroy

  # default_scope order: 'score DESC'
  scope :bottom, order(:score)

  alias_method :subject, :report # for the score evidence pop-up

  scope :by_score, order('report_scores.score DESC')
  scope :with_evidence, includes([
    {politician: :state},
    :evidence
  ])

  scope :with, where("report_scores.score > 66.667")
  scope :against, where("report_scores.score < 33.333")
  scope :neutral, where("report_scores.score BETWEEN 33.333 AND 66.667")
  class << self
    def votes_how(how)
      send(how.to_sym)
    end
  end

  has_many :dependent_report_score_evidences, class_name: 'ReportScoreEvidence', as: :evidence
  has_many :dependent_report_scores, class_name: 'ReportScore',
    through: :dependent_report_score_evidences, source: :score

  scope :for_politician_display, includes(report: [:cause, :image, :interest_group, :user, :top_subject]).order('report_scores.score DESC')
  scope :for_report_display, includes(politician: [:state, :congressional_district]).order('report_scores.score DESC')

  scope :published, joins(:report).where([
    "reports.state = ? OR reports.user_id IS NULL", 'published'])

  scope :for_causes, joins(:report).where(['reports.cause_id IS NOT NULL'])
  scope :for_published_reports, joins(:report).where([
    "(reports.state = ? OR reports.user_id IS NULL) AND reports.cause_id IS NULL", 'published'])

  scope :for_reports_with_subjects, lambda {|subjects|
    subjects = Array(subjects)
    if subjects.empty?
      {}
    else
      select('DISTINCT report_scores.*')\
      .joins(report: :subjects)\
      .where((subjects.first.is_a?(String) \
       ? ["subjects.name IN(?) OR subjects.cached_slug IN(?)", subjects, subjects] \
       : ['subjects.id IN(?)', subjects]))
    end
  }

  scope :for_politicians, lambda {|politicians|
    politicians = Array(politicians)
    if politicians.empty? || politicians.first == Politician
      {}
    else
      where(politician_id: politicians)
    end
  }

  scope :for_reports, lambda {|reports|
    reports = Array(reports)
    if reports.empty?
      {}
    else
      where(report_id: reports)
    end
  }

  paginates_per 12

  before_destroy :rescore_dependent_reports

  def to_s
    letter_grade
  end

  def event_date
    Date.today
  end

  def opposition_score
    # for guide opposition
    -(score - 50.0) + 50.0
  end

  def as_json(opts = {})
    super(opts.reverse_merge(only: [:evidence_description, :gov_track_id, :vote_smart_id, :score, :name], include: [:politician]))
  end

  private

  def rescore_dependent_reports
    dependent_report_scores.each do |dependent_score|
      dependent_score.report.rescore!
      dependent_score.destroy
    end
  end
end
