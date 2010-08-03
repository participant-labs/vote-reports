class AmendmentCriterion < ActiveRecord::Base
  include Criterion

  belongs_to :amendment
  validates_presence_of :amendment, :report

  validates_uniqueness_of :amendment_id, :scope => "report_id"

  accepts_nested_attributes_for :amendment

  def events
    amendment.passage_rolls.all(:include => {:votes => [{:politician => :state}, :roll]}).map(&:votes).flatten
  end

  def event_score(vote)
    if aligns?(vote)
      100.0
    elsif contradicts?(vote)
      0.0
    else
      50.0
    end
  end
end
