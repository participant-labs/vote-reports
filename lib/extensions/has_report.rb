module HasReport
  def self.included(base)
    base.class_eval do
      has_one :report
      delegate :causes, :bill_criteria, :rescore!, :to => :report

      before_validation_on_create :initialize_report
      after_update :update_report

      validates_presence_of :report, :name
    end
  end

  private

  def update_report
    if name_changed? || description_changed?
      (report || build_report).update_attributes!(:name => name, :description => description)
    end
  end

  def initialize_report
    build_report(:name => name)
  end
end
