class Guide < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  belongs_to :congressional_district

  has_friendly_id :secure_token

  has_many :guide_reports
  has_many :reports, :through => :guide_reports

  before_validation_on_create :initialize_report
  delegate :scores, :to => :report

  validates_presence_of :secure_token, :report

  delegate :scores, :rescore!, :to => :report

  alias_method :score_criteria, :guide_reports

  def immediate_scores
    return [] unless congressional_district.present? && reports.present?
    report_ids = reports.map(&:id)
    congressional_district.politicians.map do |politician|
      next unless reports.any? {|report| report.scores.for_politicians(politician).present? }
      GuideScore.first(:conditions => {:politician_id => politician.id, :report_ids.all => report_ids, :report_ids.size => report_ids.size}) \
       || GuideScore.create!(:politician_id => politician.id, :report_ids => report_ids)
    end.compact
  end

  def next_issue
    cause = Cause.random.first
    cause.issues.random.first || cause
  end

  private

  def initialize_report
    self.secure_token = ActiveSupport::SecureRandom.hex(10)
    build_report(:name => secure_token, :guide => self).save!
  end
end
