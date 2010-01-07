class Committee < ActiveRecord::Base
  acts_as_tree

  has_many :names, :class_name => 'CommitteeName'
  has_many :memberships, :class_name => 'CommitteeMembership'

  named_scope :with_name, lambda {|name|
    {:joins => :names, :conditions => {:'committee_names.name' => name}}
  }
end
