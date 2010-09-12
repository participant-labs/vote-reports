class MoveAllSponsporshipDataToCosponsorshipObjects < ActiveRecord::Migration
  class Bill < ActiveRecord::Base
    belongs_to :sponsor, :class_name => 'Politician'
    has_many :cosponsorships
    has_many :cosponsors, :through => :cosponsorships, :source => :politician
    has_one :sponsorship, :class_name => 'Cosponsorship'
  end

  def self.up
    say_with_time "Moving bill sponsors to cosponsorship objects" do
      add_column :bills, :sponsorship_id, :integer
      add_foreign_key :bills, :cosponsorships, :column => :sponsorship_id
      add_index :bills, :sponsorship_id, :unique => true
      Bill.paginated_each(:conditions => "bills.sponsor_id IS NOT NULL") do |bill|
        sponsorship = bill.cosponsorships.create!(:politician_id => bill.sponsor_id, :joined_on => bill.introduced_on)
        bill.update_attribute(:sponsorship_id, sponsorship.id)
        print '.'
      end
      remove_column :bills, :sponsor_id
    end
  end

  def self.down
    raise "nope"
  end
end
