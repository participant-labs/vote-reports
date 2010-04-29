class ConstrainCommitteeMeetingNamesToNotBeBlank < ActiveRecord::Migration
  def self.up
    constrain :committee_meetings, :name, :not_blank => true
  end

  def self.down
    deconstrain :committee_meetings, :name, :not_blank
  end
end
