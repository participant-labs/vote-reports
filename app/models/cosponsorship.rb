class Cosponsorship < ActiveRecord::Base
  belongs_to :politician
  belongs_to :bill

  def verb
    if bill.sponsorship == self
      'introduced'
    else
      'cosponsored'
    end
  end

  # for compliance with Criterion & scoring
  def aye?
    true
  end
  def nay?
    false
  end
  def event_date
    bill.introduced_on
  end
  def subject
    bill
  end
end
