class Guide < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  has_friendly_id :secure_token

  has_many :guide_reports
  has_many :reports_supported, :through => :guide_reports, :conditions => {:guide_reports => {:position => 'support'}}, :source => :report
  has_many :reports_opposed, :through => :guide_reports, :conditions => {:guide_reports => {:position => 'oppose'}}, :source => :report

  before_validation_on_create :initialize_report
  delegate :scores, :to => :report

  validates_presence_of :secure_token, :report

  delegate :scores, :rescore!, :to => :report

  alias_method :score_criteria, :guide_reports

  def immediate_scores
    return [] unless politicians.present? && (reports_supported.present? || reports_opposed.present?)
    supported_report_ids = reports_supported.map(&:id)
    opposed_report_ids = reports_opposed.map(&:id)
    report_ids = supported_report_ids + opposed_report_ids
    politicians.map do |politician|
      if ReportScore.scoped(:conditions => {:politician_id => politician.id, :report_id => report_ids}).exists?
        GuideScore.first(:conditions => {:politician_id => politician.id, :supported_report_ids.all => supported_report_ids, :supported_report_ids.size => supported_report_ids.size, :opposed_report_ids.all => opposed_report_ids, :opposed_report_ids.size => opposed_report_ids.size}) \
         || GuideScore.create!(:politician_id => politician.id, :supported_report_ids => supported_report_ids, :opposed_report_ids => opposed_report_ids)
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
    @politicians ||= Politician.from_congressional_district(congressional_district).in_office
  end

  def congressional_district
    @congressional_district ||= District.lookup(geoloc).detect(&:federal?).congressional_district
  end

  attr_accessor :geoloc

  private

  def initialize_report
    self.secure_token = ActiveSupport::SecureRandom.hex(10)
    build_report(:name => secure_token, :guide => self).save!
  end
end
