class Guide < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  belongs_to :zip_code
  belongs_to :district

  has_friendly_id :secure_token

  has_many :guide_reports
  has_many :reports, :through => :guide_reports

  before_validation_on_create :initialize_report
  delegate :scores, :to => :report

  validates_presence_of :secure_token, :report

  delegate :scores, :rescore!, :to => :report

  alias_method :score_criteria, :guide_reports

  def zip_code=(zip_code)
    return if zip_code.blank?

    unless zip_code.is_a?(ZipCode)
      zip_code, plus_4 = ZipCode.sections_of(zip_code)
      zip_code = ZipCode.find_by_zip_code(zip_code)
      districts = District.with_zip(zip_code)
      self[:district_id] = districts.first.id if districts.size == 1
    end
    self[:zip_code_id] = zip_code.id
    self[:plus_4] = plus_4 if plus_4.present?
    
    zip_code
  end

  def full_zip
    [zip_code, plus_4].map(&:presence).compact.join('-')
  end

  private

  def initialize_report
    self.secure_token = ActiveSupport::SecureRandom.hex(10)
    build_report(:name => secure_token).save!
  end
end
