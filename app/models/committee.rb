class Committee < ActiveRecord::Base
  has_ancestry

  has_many :meetings, class_name: 'CommitteeMeeting' do
    def for_congress(congress, name = nil)
      create_with(name: name).find_or_create_by(congress_id: congress.id).tap do |meeting|
        raise meeting.errors.full_messages.inspect unless meeting.valid?
      end
    end
  end

  alias_method :subcommittees, :children
  def subcommittee_meetings
    CommitteeMeeting.where(committee_id: subcommittees)
  end
end
