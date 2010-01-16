class Vote < ActiveRecord::Base
  belongs_to :politician
  belongs_to :roll

  validates_uniqueness_of :roll_id, :scope => :politician_id
  validates_presence_of :politician, :roll
  validates_inclusion_of :vote, :in => %w[ + - P 0 ]

  named_scope :aye, :conditions => {:vote => '+'}
  named_scope :nay, :conditions => {:vote => '-'}
  named_scope :present, :conditions => {:vote => 'P'}
  named_scope :not_voting, :conditions => {:vote => '0'}

  def aye?
    vote == '+'
  end

  def nay?
    vote == '-'
  end
end
