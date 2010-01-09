module Term
  def acts_as_term
    belongs_to :politician
    belongs_to :party
    validates_presence_of :politician, :party
  end
end

ActiveRecord::Base.extend Term