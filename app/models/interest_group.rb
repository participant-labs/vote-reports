class InterestGroup < ActiveRecord::Base
  has_ancestry

  has_many :interest_group_subjects
  has_many :subjects, :through => :interest_group_subjects

  has_many :reports, :class_name => 'InterestGroupReport'
  has_many :ratings, :through => :reports
  def rated_politicians
    Politician.scoped(
      :select => 'DISTINCT politicians.*',
      :joins => {:ratings => :reports},
      :conditions => {:'reports.interest_group_id' => self})
  end

  named_scope :for_subjects, lambda {|subjects|
    if subjects.blank?
      {}
    else
      if subjects.first.is_a?(String)
        subjects = Subject.find(subjects)
      end
      {
        :select => 'DISTINCT interest_groups.*', :joins => :interest_group_subjects,
        :conditions => {:'interest_group_subjects.subject_id' => subjects}
      }
    end
  }
end
