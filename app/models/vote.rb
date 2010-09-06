class Vote < ActiveRecord::Base
  POSSIBLE_VALUES = %w[ + - P 0 ]

  belongs_to :politician
  belongs_to :roll

  validates_uniqueness_of :roll_id, :scope => :politician_id
  validates_presence_of :politician, :roll
  validates_inclusion_of :vote, :in => POSSIBLE_VALUES

  default_scope :include => :politician
  named_scope :aye, :conditions => {:vote => '+'}
  named_scope :nay, :conditions => {:vote => '-'}
  named_scope :present, :conditions => {:vote => 'P'}
  named_scope :not_voting, :conditions => {:vote => '0'}

  delegate :subject, :to => :roll

  named_scope :for_display, :include => {:politician => [:state, :congressional_district]}

  def position
    {'+' => 'Aye',
     '-' => 'Nay',
     'P' => 'Present',
     '0' => 'Not Voting'}[vote]
  end

  def aye?
    vote == '+'
  end

  def nay?
    vote == '-'
  end

  def event_date
    roll.voted_at.to_date
  end
end
