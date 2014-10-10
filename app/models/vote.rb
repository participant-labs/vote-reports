class Vote < ActiveRecord::Base
  POSSIBLE_VALUES = %w[ + - P 0 ]

  belongs_to :politician
  belongs_to :roll

  validates_uniqueness_of :roll_id, scope: :politician_id
  validates_presence_of :politician, :roll
  validates_inclusion_of :vote, in: POSSIBLE_VALUES

  scope :aye, -> { where(vote: '+') }
  scope :nay, -> { where(vote: '-') }
  scope :present, -> { where(vote: 'P') }
  scope :not_voting, -> { where(vote: '0') }

  delegate :subject, to: :roll

  scope :for_display, -> { includes(politician: [:state, :congressional_district]) }

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
