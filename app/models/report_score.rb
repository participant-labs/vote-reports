class ReportScore < ActiveRecord::Base
  belongs_to :report
  belongs_to :politician
  has_many :evidence, :class_name => 'ReportScoreEvidence', :dependent => :destroy

  named_scope :with_evidence, :include => {
    :politician => :state,
    :evidence => [{:vote => {:roll => {:subject => {:titles => :as}}}}, :bill_criterion]
  }

  class << self
    def per_page
      20
    end
  end
end
