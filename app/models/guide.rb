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

  private

  def initialize_report
    self.secure_token = ActiveSupport::SecureRandom.hex(10)
    build_report(:name => secure_token).save!
  end
end
