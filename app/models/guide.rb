class Guide < ActiveRecord::Base
  extend FriendlyId
  friendly_id :secure_token

  belongs_to :report
  belongs_to :user

  has_many :guide_reports
  has_many :reports_supported, -> { where(guide_reports: {position: 'support'}) }, through: :guide_reports, source: :report
  has_many :reports_opposed, -> { where(guide_reports: {position: 'oppose'}) }, through: :guide_reports, source: :report

  before_validation :initialize_report, on: :create
  validates_presence_of :secure_token, :report

  delegate :scores, :rescore!, to: :report

  alias_method :score_criteria, :guide_reports

  def immediate_scores
    return [] unless politicians.present? && (reports_supported.present? || reports_opposed.present?)
    supported_report_ids = reports_supported.map(&:id)
    opposed_report_ids = reports_opposed.map(&:id)
    report_ids = supported_report_ids + opposed_report_ids
    politicians.map do |politician|
      if ReportScore.where(politician_id: politician.id, report_id: report_ids).exists?
        GuideScore.where(politician_id: politician.id, supported_report_ids: {"$all" => supported_report_ids, "$size" => supported_report_ids.size}, opposed_report_ids: {"$all" => opposed_report_ids, "$size" => opposed_report_ids.size}).first \
         || GuideScore.create!(politician_id: politician.id, supported_report_ids: supported_report_ids, opposed_report_ids: opposed_report_ids)
      end
    end.compact
  end

  def questions
    @questions ||= GuideQuestion.all
  end

  def unanswered_question
    reports = reports_supported + reports_opposed
    unanswered = nil
    begin
      unanswered = questions.sample
    end while unanswered.answered_by?(reports)
    unanswered
  end

  def politicians
    @politicians ||= Politician.from_congressional_district(congressional_district).in_office_normal_form.for_display \
      | Politician.select('distinct politicians.*').joins(:candidacies).where(candidacies: {id: candidacies}).for_display
  end

  def districts
    @districts ||= District.lookup(geoloc)
  end

  def state
    @state ||= districts.first.state
  end

  def congressional_district
    @congressional_district ||= districts.detect(&:federal?).congressional_district
  end

  def elections
    @elections ||= state.elections(include: :stages)
  end

  def races
    @races ||= Race.for_districts(districts).upcoming
  end

  def candidacies
    @candidacies ||= Candidacy.upcoming_for_districts(districts).valid
  end

  attr_accessor :geoloc

  private

  def initialize_report
    self.secure_token = ActiveSupport::SecureRandom.hex(10)
    build_report(name: secure_token, guide: self).save!
  end
end
