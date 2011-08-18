class Cause < ActiveRecord::Base
  include HasReport

  has_many :cause_reports, :dependent => :destroy
  has_many :reports, :through => :cause_reports do
    def report_subjects
      ReportSubject.where(:report_id => self)
    end
  end

  has_many :issue_causes, :dependent => :destroy
  has_many :issues, :through => :issue_causes

  scope :without_issue,
    joins('LEFT OUTER JOIN issue_causes ON issue_causes.cause_id = causes.id').where(:'issue_causes.issue_id' => nil)

  scope :random, order('random()')

  def related_causes
    Cause.joins(:issue_causes).where(['causes.id NOT IN(?) AND issue_causes.issue_id IN(?)', self, issues])
  end

  accepts_nested_attributes_for :cause_reports, :reject_if => proc {|attributes| attributes['support'] == '0' }

  has_friendly_id :name, :use_slug => true

  validates_presence_of :description

  alias_method :score_criteria, :cause_reports

  paginates_per 20

  def as_json(opts = {})
    super opts.reverse_merge(:only => [:name, :description, :id], :methods => [:to_param, :url], :include => :reports)
  end
end
