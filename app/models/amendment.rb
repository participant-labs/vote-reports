class Amendment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :sponsor, :polymorphic => true
  belongs_to :congress

  has_many :rolls, :as => :subject, :dependent => :destroy

  default_scope :select => 'DISTINCT amendments.*', :joins => :rolls

  def title
    purpose || description
  end
end
