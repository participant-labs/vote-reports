class ForcePresenceOfCopsonsorshipJoinedOn < ActiveRecord::Migration
  def self.up
    say_with_time "populate empty joined_ons with their bill's introduced_on" do
      Cosponsorship.all(:conditions => {:joined_on => nil}).each do |sponsorship|
        sponsorship.update_attributes!(:joined_on => sponsorship.bill.introduced_on)
        print '.'
      end
      puts
    end
    change_column_null :cosponsorships, :joined_on, false
  end

  def self.down
    change_column_null :cosponsorships, :joined_on, true
  end
end
