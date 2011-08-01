class Amendment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :sponsor, :polymorphic => true
  belongs_to :congress

  ROLL_PASSAGE_TYPES = [
    "On Agreeing to the Amendments en bloc", "On Agreeing to the Amendment"
  ]

  has_many :rolls, :as => :subject, :dependent => :destroy

  has_friendly_id :short_name, :scope => :bill
  before_validation_on_create :set_short_name

  scope :by_offered_on, order('offered_on DESC')
  scope :with_votes, joins(:rolls).select('DISTINCT amendments.*')
  scope :with_title, lambda {|title|
    where(['amendments.purpose = ? OR amendments.description = ?', title, title])
  }

  has_many :passage_rolls, :as => :subject, :class_name => 'Roll', :conditions => [
    "rolls.roll_type IN(?)", ROLL_PASSAGE_TYPES
  ]

  def title
    purpose || description
  end

  def sponsoring_politician
    sponsor if sponsor_type == 'Politician'
  end

  def display_name
    "#{chamber.upcase}.Amdt. #{number}"
  end

  private

  def set_short_name
    self.short_name = "#{chamber}-#{number}"
  end
end
