class Committee < ActiveRecord::Base
  acts_as_tree

  has_many :names, :class_name => 'CommitteeName'
  has_many :memberships, :class_name => 'CommitteeMembership'

  class << self
    def find_by_name(name)
      CommitteeName.first(:conditions => {:name => name}, :include => :committee).try(:committee)
    end
  end
end
