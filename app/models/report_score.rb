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

  named_scope :for_politicians, lambda {|politicians|
    if politicians == Politician
      {}
    else
      {:conditions => {:politician_id => politicians}}
    end
  }

  class << self
    def per_page
      20
    end
  end
end
