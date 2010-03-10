class ReportScore < ActiveRecord::Base
  belongs_to :report
  belongs_to :politician
  has_many :evidence, :class_name => 'ReportScoreEvidence', :dependent => :destroy

  default_scope :order => 'score DESC'
  named_scope :bottom, :order => :score

  named_scope :with_evidence, :include => {
    :politician => :state,
    :evidence => [{:vote => {:roll => {:subject => {:titles => :as}}}}, :bill_criterion]
  }

  named_scope :published, :joins => :report, :conditions => {:'reports.state' => 'published'}

  named_scope :for_reports_with_subject, lambda {|subject|
    if subject.is_a?(String)
      {
        :select => 'DISTINCT report_scores.*',
        :joins => {:report => {:bills => :subjects}},
        :conditions => ["subjects.name = ? OR subjects.cached_slug = ?", subject, subject]
      }
    else
      {
        :select => 'DISTINCT report_scores.*',
        :joins => {:report => {:bills => :bill_subjects}},
        :conditions => {:'bill_subjects.subject_id' => subject}
      }
    end
  }

  named_scope :for_politicians, lambda {|politicians|
    if politicians == Politician
      {}
    else
      {:conditions => {:politician_id => politicians}}
    end
  }

  class << self
    def per_page
      10
    end
  end
end
