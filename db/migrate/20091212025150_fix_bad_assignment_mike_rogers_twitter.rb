class FixBadAssignmentMikeRogersTwitter < ActiveRecord::Migration
  def self.up
    # There's another mike rogers from AL, not this one
    mike = Politician.first(:conditions => {:vote_smart_id => '8751'})
    mike.update_attributes(:twitter_id => nil) if mike.twitter_id == 'RepMikeRogersAL' && mike.state != 'AL'
  end

  def self.down
  end
end
