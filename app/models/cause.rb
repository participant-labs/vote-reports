class Cause < ActiveRecord::Base
  has_many :cause_reports
  has_many :reports, :through => :cause_reports

  has_one :report
  before_validation_on_create :initialize_report
  after_update :update_report

  accepts_nested_attributes_for :cause_reports, :reject_if => proc {|attributes| attributes['support'] == '0' }

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name, :description, :report

  delegate :rescore!, :to => :report

  alias_method :score_criteria, :cause_reports

  class << self
    def per_page
      20
    end
  end

  private

  def update_report
    if name_changed? || description_changed?
      report.update_attributes(:name => name, :description => description)
    end
  end

  def initialize_report
    build_report(:name => name)
  end
end
