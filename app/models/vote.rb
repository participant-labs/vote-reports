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

  unless Rails.env.development?
    after_create :create_bill_support_or_opposition
  end

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

  private

  unless Rails.env.development?
    def create_bill_support_or_opposition
      if roll.passage?
        BillOpposition.find_or_create_by_bill_id_and_politician_id(roll.subject.id, politician.id) if nay?
        BillSupport.find_or_create_by_bill_id_and_politician_id(roll.subject.id, politician.id) if aye?
      end
    end
  end
end
