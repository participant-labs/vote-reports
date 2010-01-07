class Committee < ActiveRecord::Base
  acts_as_tree

  has_many :meetings, :class_name => 'CommitteeMeeting'
end
