class Guide < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  has_friendly_id :secure_token

  has_many :guide_reports
  has_many :reports, :through => :guide_reports

  before_validation_on_create :initialize_report
  delegate :scores, :to => :report

  validates_presence_of :secure_token, :report

  delegate :scores, :rescore!, :to => :report

  alias_method :score_criteria, :guide_reports

  def immediate_scores
    return [] unless politicians.present? && reports.present?
    report_ids = reports.map(&:id)
    scores = ReportScore.all(:conditions => {:politician_id => politicians, :report_id => reports}).group_by(&:politician)
    scores.map do |(politician, scores)|
      GuideScore.first(:conditions => {:politician_id => politician.id, :report_ids.all => report_ids, :report_ids.size => report_ids.size}) \
       || GuideScore.create!(:politician_id => politician.id, :report_ids => report_ids, :scores => scores)
    end
  end

  def questions
    @questions ||= GuideQuestion.questions
  end

  def next_question
    questions.random_element
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
