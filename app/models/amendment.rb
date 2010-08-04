class Amendment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :sponsor, :polymorphic => true
  belongs_to :congress

  has_many :rolls, :as => :subject, :dependent => :destroy

  has_friendly_id :short_name, :scope => :bill
  before_validation_on_create :set_short_name

  named_scope :by_offered_on, :order => 'offered_on DESC'
  named_scope :with_votes, :select => 'DISTINCT amendments.*', :joins => :rolls
  named_scope :with_title, lambda {|title|
    {:conditions => ['amendments.purpose = ? OR amendments.description = ?', title, title]}
  }

  has_many :passage_rolls, :as => :subject, :class_name => 'Roll', :conditions => [
    "rolls.roll_type IN(?)", Roll::PASSAGE_TYPES
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
