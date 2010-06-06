class SyncReportsWithCauseAndInterestGroupNameAndDescriptions < ActiveRecord::Migration
  def self.up
    Cause.paginated_each do |cause|
      cause.send(:update_report)
      print '.'
    end
    puts
    InterestGroup.paginated_each do |interest_group|
      interest_group.send(:update_report)
      print '.'
    end
    puts
  end

  def self.down
  end
end
