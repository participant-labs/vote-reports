module Term
  def self.included(base)
    base.class_eval do
      belongs_to :politician
      belongs_to :party
      validates_presence_of :politician, :party
    end
  end
end
