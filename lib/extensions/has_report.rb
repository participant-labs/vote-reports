module HasReport
  def self.included(base)
    base.class_eval do
      has_one :report, :dependent => :destroy
      delegate :causes, :bill_criteria, :amendment_criteria, :rescore!, :has_criteria?, :subjects, :current_image, :thumbnail, :build_image, :image, :to => :report

      before_validation :initialize_report, on: :create
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
