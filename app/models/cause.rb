class Cause < ActiveRecord::Base
  has_many :cause_reports
  has_many :reports, :through => :cause_reports, :after_add => :rescore!, :after_remove => :rescore!

  has_one :report

  accepts_nested_attributes_for :cause_reports, :reject_if => proc {|attributes| attributes['support'] == '0' }

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name, :description

  def rescore!(ignored_report = nil)
    (report || build_report(:name => name).tap(&:save!)).rescore!
  end

  delegate :scores, :to => :report
  alias_method :score_criteria, :reports
end
