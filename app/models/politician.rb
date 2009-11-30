class Politician < ActiveRecord::Base

  has_many :votes
  has_many :bills, :through => :votes do
    def supported
      scoped(:conditions => "votes.vote = true")
    end
    def opposed
      scoped(:conditions => "votes.vote = false")
    end
  end


  def full_name= full_name
    self.last_name, self.first_name = full_name.split(', ',2)
  end

  def full_name
    [first_name, last_name].join(" ")
  end
end
