class Committee < ActiveRecord::Base
  has_ancestry

  has_many :meetings, :class_name => 'CommitteeMeeting' do
    def for_congress(congress)
      find_or_create_by_congress_id(congress).tap do |meeting|
        raise meeting.errors.full_messages.inspect unless meeting.valid?
      end
    end
  end

  alias_method :subcommittees, :children
  def subcommittee_meetings
    CommitteeMeeting.scoped(
      :conditions => {
        :committee_id => subcommittees,
      }
    )
  end
end
