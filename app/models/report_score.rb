class ReportScore < ActiveRecord::Base
  belongs_to :report
  belongs_to :politician
  has_many :evidence, :class_name => 'ReportScoreEvidence', :dependent => :destroy

  default_scope :order => 'score DESC'
  named_scope :bottom, :order => :score

  named_scope :with_evidence, :include => [
    {:politician => :state},
    :evidence
  ]

  named_scope :published, :joins => :report, :conditions => [
    "reports.state = ? OR reports.interest_group_id IS NOT NULL", 'published']

  named_scope :for_reports_with_subjects, lambda {|subjects|
    subjects = Array(subjects)
    if subjects.empty?
      {}
    elsif subjects.first.is_a?(String)
      {
        :select => 'DISTINCT report_scores.*',
        :joins => {:report => :subjects},
        :conditions => ["subjects.name IN(?) OR subjects.cached_slug IN(?)", subjects, subjects]
      }
    else
      {
        :select => 'DISTINCT report_scores.*',
        :joins => {:report => :subjects},
        :conditions => ['subjects.id IN(?)', subjects]
      }
    end
  }

  named_scope :for_politicians, lambda {|politicians|
    politicians = Array(politicians)
    if politicians.empty?
      {}
    else
      {:conditions => {:politician_id => politicians}}
    end
  }

  named_scope :for_reports, lambda {|reports|
    reports = Array(reports)
    if reports.empty?
      {}
    else
      {:conditions => {:report_id => reports}}
    end
  }

  class << self
    def per_page
      10
    end
  end

  def to_s
    "#{score.round}%"
  end

  def event_date
    Date.today
  end
end
