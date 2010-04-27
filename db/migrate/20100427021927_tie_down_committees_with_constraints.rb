class TieDownCommitteesWithConstraints < ActiveRecord::Migration
  def self.up
    add_index :congresses, :meeting, :unique => true
    add_index :committees, [:code, :ancestry], :unique => true
    add_index :committee_memberships, [:politician_id, :committee_meeting_id], :unique => true, :name => 'index_committee_memberships_on_pol_id_and_com_meeting_id'

    CommitteeMeeting.all(:select => 'DISTINCT congress_id, committee_id').each do |meeting|
      matching = CommitteeMeeting.scoped(:conditions => meeting.attributes)
      keep = matching.first(:order => 'created_at')
      matching.delete_all(['id != ?', keep])
    end
    add_index :committee_meetings, [:congress_id, :committee_id], :unique => true

    add_index :bills, :opencongress_id, :unique => true
    add_index :bills, :gov_track_id, :unique => true
    add_index :bills, [:congress_id, :bill_type, :bill_number], :unique => true
  end

  def self.down
    raise 'Nope'
  end
end
