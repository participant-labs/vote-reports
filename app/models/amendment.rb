class Amendment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :sponsor, :polymorphic => true
  belongs_to :congress

  has_many :rolls, :as => :subject, :dependent => :destroy

  named_scope :by_offered_on, :order => 'offered_on DESC'
  named_scope :with_votes, :select => 'DISTINCT amendments.*', :joins => :rolls

  def title
    purpose || description
  end

  def sponsoring_politician
    sponsor if sponsor_type == 'Politician'
  end
end
